import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  Inject,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserDocumentRepository } from '../repositories/user-document.repository';
import { STORAGE_SERVICE_TOKEN, IStorageService } from '../interfaces/storage-service.interface';
import { ProfileCompletionService } from './profile-completion.service';
import { DocumentType } from '../constants/document-type.enum';
import { UploadDocumentDto } from '../dto/upload-document.dto';
import { DocumentResponseDto } from '../dto/document-response.dto';
import { DocumentMapper } from '../mappers/document.mapper';
import { AvatarUploadedEvent, PROFILE_EVENT_TOKENS } from '../events/profile-events';
import { CLOUDINARY_FOLDERS, UPLOAD_LIMITS } from '../constants/upload-constants';

@Injectable()
export class ProfileUploadService {
  constructor(
    private readonly profileRepository: UserProfileRepository,
    private readonly documentRepository: UserDocumentRepository,
    @Inject(STORAGE_SERVICE_TOKEN) private readonly storageService: IStorageService,
    private readonly completionService: ProfileCompletionService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async uploadAvatar(
    userId: string,
    file: Express.Multer.File,
  ): Promise<{ avatarUrl: string }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    // Delete old avatar from Cloudinary if present
    if (profile.avatarPublicId) {
      await this.storageService.deleteFile(profile.avatarPublicId, 'image');
    }

    // Upload asset to Cloudinary with thumbnail transformation
    const uploadResult = await this.storageService.uploadFile(
      file.buffer,
      file.originalname,
      {
        folder: CLOUDINARY_FOLDERS.AVATARS,
        transformation: { width: 500, height: 500, crop: 'fill', gravity: 'face' },
        resourceType: 'image',
      },
    );

    profile.avatar = uploadResult.secureUrl;
    profile.avatarPublicId = uploadResult.publicId;

    await this.profileRepository.save(profile, userId);
    await this.recalculateProfileCompletion(profile.id);

    // Emit event
    this.eventEmitter.emit(
      PROFILE_EVENT_TOKENS.AVATAR_UPLOADED,
      new AvatarUploadedEvent(profile.id, userId, uploadResult.secureUrl),
    );

    return { avatarUrl: uploadResult.secureUrl };
  }

  async deleteAvatar(userId: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    if (profile.avatarPublicId) {
      await this.storageService.deleteFile(profile.avatarPublicId, 'image');
    }

    profile.avatar = null;
    profile.avatarPublicId = null;

    await this.profileRepository.save(profile, userId);
    await this.recalculateProfileCompletion(profile.id);

    return { success: true };
  }

  async uploadResume(
    userId: string,
    file: Express.Multer.File,
  ): Promise<DocumentResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    // Check if primary resume exists, delete Cloudinary asset & entity
    const existingResume = await this.documentRepository.findPrimaryResume(profile.id);
    if (existingResume) {
      await this.storageService.deleteFile(existingResume.publicId, 'raw');
      await this.documentRepository.hardDelete(existingResume.id);
    }

    const uploadResult = await this.storageService.uploadFile(
      file.buffer,
      file.originalname,
      {
        folder: CLOUDINARY_FOLDERS.RESUMES,
        resourceType: 'raw',
      },
    );

    const docEntity = this.documentRepository.create(
      {
        profileId: profile.id,
        documentType: DocumentType.RESUME,
        title: file.originalname,
        fileUrl: uploadResult.secureUrl,
        publicId: uploadResult.publicId,
        mimeType: file.mimetype,
        fileSize: file.size,
        isPrimaryResume: true,
        metadata: {
          originalName: file.originalname,
          format: uploadResult.format,
          bytes: uploadResult.bytes,
        },
      },
      userId,
    );

    const savedDoc = await this.documentRepository.save(docEntity, userId);
    await this.recalculateProfileCompletion(profile.id);

    return DocumentMapper.toDto(savedDoc);
  }

  async deleteResume(userId: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const existingResume = await this.documentRepository.findPrimaryResume(profile.id);
    if (!existingResume) {
      throw new NotFoundException('No active primary resume found to delete.');
    }

    await this.storageService.deleteFile(existingResume.publicId, 'raw');
    await this.documentRepository.hardDelete(existingResume.id);
    await this.recalculateProfileCompletion(profile.id);

    return { success: true };
  }

  async uploadSupportingDocument(
    userId: string,
    dto: UploadDocumentDto,
    file: Express.Multer.File,
  ): Promise<DocumentResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const totalDocs = await this.documentRepository.countByProfileId(profile.id);
    if (totalDocs >= UPLOAD_LIMITS.MAX_SUPPORTING_DOCUMENTS_PER_USER) {
      throw new BadRequestException(
        `Maximum supporting document upload limit (${UPLOAD_LIMITS.MAX_SUPPORTING_DOCUMENTS_PER_USER}) reached.`,
      );
    }

    const uploadResult = await this.storageService.uploadFile(
      file.buffer,
      file.originalname,
      {
        folder: CLOUDINARY_FOLDERS.DOCUMENTS,
        resourceType: 'raw',
      },
    );

    const docEntity = this.documentRepository.create(
      {
        profileId: profile.id,
        documentType: dto.documentType || DocumentType.OTHER,
        title: dto.title.trim(),
        fileUrl: uploadResult.secureUrl,
        publicId: uploadResult.publicId,
        mimeType: file.mimetype,
        fileSize: file.size,
        isPrimaryResume: false,
        metadata: {
          originalName: file.originalname,
          format: uploadResult.format,
          bytes: uploadResult.bytes,
        },
      },
      userId,
    );

    const savedDoc = await this.documentRepository.save(docEntity, userId);
    await this.recalculateProfileCompletion(profile.id);

    return DocumentMapper.toDto(savedDoc);
  }

  async getDocuments(userId: string): Promise<DocumentResponseDto[]> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const docs = await this.documentRepository.findByProfileId(profile.id);
    return DocumentMapper.toDtoList(docs);
  }

  async deleteDocument(userId: string, documentId: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const doc = await this.documentRepository.findById(documentId);
    if (!doc) {
      throw new NotFoundException(`Document with ID ${documentId} not found.`);
    }

    if (doc.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested document.');
    }

    await this.storageService.deleteFile(doc.publicId, 'raw');
    await this.documentRepository.hardDelete(documentId);
    await this.recalculateProfileCompletion(profile.id);

    return { success: true };
  }

  private async recalculateProfileCompletion(profileId: string): Promise<void> {
    const profile = await this.profileRepository.findByProfileIdWithRelations(profileId);
    if (profile) {
      const breakdown = this.completionService.calculateCompletion(profile);
      await this.profileRepository.updateCompletionPercentage(
        profileId,
        breakdown.totalPercentage,
      );
    }
  }
}
