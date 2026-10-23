import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsEnum } from 'class-validator';
import { MediaVisibility } from '../constants/media-enums.constants';

export class UpdateMediaDto {
  @ApiPropertyOptional({ description: 'Updated folder classification' })
  @IsOptional()
  @IsString()
  folder?: string;

  @ApiPropertyOptional({ description: 'Updated access visibility', enum: MediaVisibility })
  @IsOptional()
  @IsEnum(MediaVisibility)
  visibility?: MediaVisibility;
}
