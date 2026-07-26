import { MediaFile } from '../entities/media-file.entity';
import { MediaFolder } from '../entities/media-folder.entity';
import { MediaResponseDto } from '../dto/media-response.dto';
import { MediaFolderResponseDto } from '../dto/media-folder-response.dto';

export class MediaMapper {
  static toMediaResponseDto(entity: MediaFile): MediaResponseDto {
    return {
      id: entity.id,
      originalName: entity.originalName,
      mimeType: entity.mimeType,
      extension: entity.extension,
      size: Number(entity.size),
      width: entity.width,
      height: entity.height,
      provider: entity.provider,
      folder: entity.folder,
      url: entity.url,
      thumbnailUrl: entity.thumbnailUrl,
      status: entity.status,
      visibility: entity.visibility,
      createdAt: entity.createdAt,
    };
  }

  static toFolderDto(entity: MediaFolder): MediaFolderResponseDto {
    return {
      id: entity.id,
      name: entity.name,
      folderType: entity.folderType,
      parentId: entity.parentId,
    };
  }
}
