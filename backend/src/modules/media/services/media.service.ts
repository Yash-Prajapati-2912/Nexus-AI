import { Injectable, Logger, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MediaFileRepository } from '../repositories/media-file.repository';
import { MediaFolderRepository } from '../repositories/media-folder.repository';
import { MediaVersionRepository } from '../repositories/media-version.repository';
import { MediaAccessLogRepository } from '../repositories/media-access-log.repository';
import { MediaUsageRepository } from '../repositories/media-usage.repository';
import { StorageProviderFactory } from '../factories/storage-provider.factory';
import { ImageOptimiserService } from '../optimisers/image-optimiser.service';
import { MediaCacheService } from './media-cache.service';
import { MediaQueueProcessor } from '../queues/media.queue';

import { UploadMediaDto } from '../dto/upload-media.dto';
import { UpdateMediaDto } from '../dto/update-media.dto';
import { MediaResponseDto } from '../dto/media-response.dto';
import { MediaFolderResponseDto } from '../dto/media-folder-response.dto';
import { MediaMapper } from '../mappers/media.mapper';
import { MediaVisibility, MediaStatus, StorageProviderType } from '../constants/media-enums.constants';

@Injectable()
export class MediaService {
  private readonly logger = new Logger(MediaService.name);

  constructor(
    private readonly mediaFileRepository: MediaFileRepository,
    private readonly mediaFolderRepository: MediaFolderRepository,
    private readonly mediaVersionRepository: MediaVersionRepository,
    private readonly mediaAccessLogRepository: MediaAccessLogRepository,
    private readonly mediaUsageRepository: MediaUsageRepository,
    private readonly providerFactory: StorageProviderFactory,
    private readonly imageOptimiser: ImageOptimiserService,
    private readonly cacheService: MediaCacheService,
    private readonly queueProcessor: MediaQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async uploadFile(
    ownerId: string,
    fileBuffer: Buffer,
    originalName: string,
    mimeType: string,
    dto: UploadMediaDto,
  ): Promise<MediaResponseDto> {
    if (!fileBuffer || fileBuffer.length === 0) {
      throw new BadRequestException('Empty or invalid file payload');
    }

    const providerType = dto.providerOverride
      ? (dto.providerOverride as StorageProviderType)
      : undefined;

    const provider = this.providerFactory.getProvider(providerType);

    let width: number | undefined;
    let height: number | undefined;
    let processedBuffer = fileBuffer;

    if (mimeType.startsWith('image/')) {
      const opt = await this.imageOptimiser.processAndOptimise(fileBuffer, mimeType);
      processedBuffer = opt.optimisedBuffer;
      width = opt.width;
      height = opt.height;
    }

    const uploadRes = await provider.upload({
      ownerId,
      filename: originalName,
      buffer: processedBuffer,
      mimeType,
      folder: dto.folder || 'General',
      moduleName: dto.moduleName || 'SYSTEM',
    });

    const ext = originalName.includes('.') ? originalName.split('.').pop() || 'bin' : 'bin';

    const entity = this.mediaFileRepository.create(
      {
        ownerId,
        originalName,
        storedName: uploadRes.storedName,
        mimeType,
        extension: ext,
        size: uploadRes.size,
        width: width || uploadRes.width || null,
        height: height || uploadRes.height || null,
        duration: null,
        checksum: `sha256_${Date.now()}_${uploadRes.size}`,
        provider: uploadRes.provider,
        bucket: uploadRes.bucket || null,
        folder: dto.folder || 'General',
        url: uploadRes.url,
        thumbnailUrl: uploadRes.thumbnailUrl || null,
        previewUrl: uploadRes.url,
        moduleName: dto.moduleName || 'SYSTEM',
        status: MediaStatus.READY,
        visibility: dto.visibility || MediaVisibility.AUTHENTICATED,
      },
      ownerId,
    );

    const saved = await this.mediaFileRepository.save(entity, ownerId);
    this.eventEmitter.emit('media.uploaded', { fileId: saved.id, ownerId });

    return MediaMapper.toMediaResponseDto(saved);
  }

  async uploadMultipleFiles(
    ownerId: string,
    files: Array<{ buffer: Buffer; originalName: string; mimeType: string }>,
    dto: UploadMediaDto,
  ): Promise<MediaResponseDto[]> {
    const results: MediaResponseDto[] = [];
    for (const f of files) {
      const res = await this.uploadFile(ownerId, f.buffer, f.originalName, f.mimeType, dto);
      results.push(res);
    }
    return results;
  }

  async getFileById(ownerId: string, fileId: string): Promise<MediaResponseDto> {
    const file = await this.mediaFileRepository.findById(fileId);
    if (!file) {
      throw new NotFoundException('Media file not found');
    }
    if (file.visibility === MediaVisibility.PRIVATE && file.ownerId !== ownerId) {
      throw new ForbiddenException('Access denied to private media file');
    }
    return MediaMapper.toMediaResponseDto(file);
  }

  async getUserFiles(
    ownerId: string,
    folder?: string,
    page: number = 1,
    limit: number = 20,
  ) {
    const { data, total } = await this.mediaFileRepository.findUserFiles(ownerId, folder, page, limit);
    return {
      files: data.map(MediaMapper.toMediaResponseDto),
      total,
      page,
      limit,
    };
  }

  async updateFile(ownerId: string, fileId: string, dto: UpdateMediaDto): Promise<MediaResponseDto> {
    const file = await this.mediaFileRepository.findById(fileId);
    if (!file || file.ownerId !== ownerId) {
      throw new NotFoundException('Media file not found or unauthorized');
    }

    if (dto.visibility) file.visibility = dto.visibility;
    if (dto.folder) file.folder = dto.folder;

    const saved = await this.mediaFileRepository.save(file, ownerId);
    return MediaMapper.toMediaResponseDto(saved);
  }

  async softDeleteFile(ownerId: string, fileId: string): Promise<{ success: boolean }> {
    const file = await this.mediaFileRepository.findById(fileId);
    if (!file || file.ownerId !== ownerId) {
      throw new NotFoundException('Media file not found or unauthorized');
    }
    await this.mediaFileRepository.softDeleteById(fileId, ownerId);
    this.eventEmitter.emit('media.deleted', { fileId, ownerId });
    return { success: true };
  }

  async restoreFile(ownerId: string, fileId: string): Promise<{ success: boolean }> {
    await this.mediaFileRepository.restore(fileId);
    return { success: true };
  }

  async getFolders(userId: string): Promise<MediaFolderResponseDto[]> {
    const folders = await this.mediaFolderRepository.findUserFolders(userId);
    return folders.map(MediaMapper.toFolderDto);
  }

  async generateSignedUrl(ownerId: string, fileId: string, expiresInSeconds: number = 3600): Promise<{ signedUrl: string }> {
    const file = await this.mediaFileRepository.findById(fileId);
    if (!file || file.ownerId !== ownerId) {
      throw new NotFoundException('Media file not found or unauthorized');
    }
    const provider = this.providerFactory.getProvider(file.provider);
    const signedUrl = await provider.generateSignedUrl(file.storedName, expiresInSeconds);
    return { signedUrl };
  }
}
