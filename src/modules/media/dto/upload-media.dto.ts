import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsEnum } from 'class-validator';
import { MediaVisibility, StorageProviderType } from '../constants/media-enums.constants';

export class UploadMediaDto {
  @ApiPropertyOptional({ description: 'Folder classification', example: 'Profile' })
  @IsOptional()
  @IsString()
  folder?: string;

  @ApiPropertyOptional({ description: 'Originating module name', example: 'PROFILE' })
  @IsOptional()
  @IsString()
  moduleName?: string;

  @ApiPropertyOptional({ description: 'Media visibility access control', enum: MediaVisibility })
  @IsOptional()
  @IsEnum(MediaVisibility)
  visibility?: MediaVisibility;

  @ApiPropertyOptional({ description: 'Optional storage provider override', enum: StorageProviderType })
  @IsOptional()
  @IsEnum(StorageProviderType)
  providerOverride?: StorageProviderType;
}
