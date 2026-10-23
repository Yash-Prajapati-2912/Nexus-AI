import { UserDocument } from '../entities/user-document.entity';
import { DocumentResponseDto } from '../dto/document-response.dto';

export class DocumentMapper {
  static toDto(entity: UserDocument): DocumentResponseDto {
    const dto = new DocumentResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.documentType = entity.documentType;
    dto.title = entity.title;
    dto.fileUrl = entity.fileUrl;
    dto.publicId = entity.publicId;
    dto.mimeType = entity.mimeType;
    dto.fileSize = Number(entity.fileSize) || 0;
    dto.isPrimaryResume = entity.isPrimaryResume;
    dto.metadata = entity.metadata;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: UserDocument[]): DocumentResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
