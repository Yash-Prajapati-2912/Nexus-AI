import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MediaFolderType } from '../constants/media-enums.constants';

export class MediaFolderResponseDto {
  @ApiProperty({ description: 'Folder UUID' })
  id: string;

  @ApiProperty({ description: 'Folder name' })
  name: string;

  @ApiProperty({ description: 'Folder classification type', enum: MediaFolderType })
  folderType: MediaFolderType;

  @ApiPropertyOptional({ description: 'Parent folder UUID' })
  parentId?: string | null;
}
