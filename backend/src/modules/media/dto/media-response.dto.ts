import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { StorageProviderType, MediaVisibility, MediaStatus } from '../constants/media-enums.constants';

export class MediaResponseDto {
  @ApiProperty({ description: 'Media File UUID' })
  id: string;

  @ApiProperty({ description: 'Original filename' })
  originalName: string;

  @ApiProperty({ description: 'MIME type string', example: 'image/jpeg' })
  mimeType: string;

  @ApiProperty({ description: 'File extension', example: 'jpg' })
  extension: string;

  @ApiProperty({ description: 'File size in bytes', example: 1048576 })
  size: number;

  @ApiPropertyOptional({ description: 'Image/video width in pixels' })
  width?: number | null;

  @ApiPropertyOptional({ description: 'Image/video height in pixels' })
  height?: number | null;

  @ApiProperty({ description: 'Active storage provider', enum: StorageProviderType })
  provider: StorageProviderType;

  @ApiProperty({ description: 'Target folder path', example: 'Profile' })
  folder: string;

  @ApiProperty({ description: 'Public/signed media URL' })
  url: string;

  @ApiPropertyOptional({ description: 'Thumbnail URL for images/videos' })
  thumbnailUrl?: string | null;

  @ApiProperty({ description: 'Media file status', enum: MediaStatus })
  status: MediaStatus;

  @ApiProperty({ description: 'Media visibility access control', enum: MediaVisibility })
  visibility: MediaVisibility;

  @ApiProperty({ description: 'Created timestamp' })
  createdAt: Date;
}
