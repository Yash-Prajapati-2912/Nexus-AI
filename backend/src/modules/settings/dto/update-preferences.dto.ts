import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsObject } from 'class-validator';

export class UpdatePreferencesDto {
  @ApiPropertyOptional({ description: 'Application view preferences' })
  @IsOptional()
  @IsObject()
  application?: Record<string, any>;

  @ApiPropertyOptional({ description: 'Planner module preferences' })
  @IsOptional()
  @IsObject()
  planner?: Record<string, any>;

  @ApiPropertyOptional({ description: 'Finance module preferences' })
  @IsOptional()
  @IsObject()
  finance?: Record<string, any>;

  @ApiPropertyOptional({ description: 'AI Mentor preferences' })
  @IsOptional()
  @IsObject()
  ai?: Record<string, any>;
}
