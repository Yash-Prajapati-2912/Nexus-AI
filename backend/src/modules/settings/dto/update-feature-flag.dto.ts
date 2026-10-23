import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsBoolean, IsOptional, IsNumber, IsArray } from 'class-validator';

export class UpdateFeatureFlagDto {
  @ApiProperty({ description: 'Feature flag unique key', example: 'ENABLE_AI_STUDY_ASSISTANT' })
  @IsNotEmpty()
  @IsString()
  key: string;

  @ApiProperty({ description: 'Enable or disable feature flag' })
  @IsNotEmpty()
  @IsBoolean()
  isEnabled: boolean;

  @ApiPropertyOptional({ description: 'Rollout percentage (0 to 100)', example: 50 })
  @IsOptional()
  @IsNumber()
  rolloutPercentage?: number;

  @ApiPropertyOptional({ description: 'Allowed user UUIDs list', type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  allowedUserIds?: string[];
}
