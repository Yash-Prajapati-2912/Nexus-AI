import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsEnum } from 'class-validator';
import { AIProviderType } from '../constants/finance-ai-enums.constants';

export class AIAnalysisRequestDto {
  @ApiPropertyOptional({ description: 'Target AI Provider override', enum: AIProviderType })
  @IsOptional()
  @IsEnum(AIProviderType)
  provider?: AIProviderType;

  @ApiPropertyOptional({ description: 'Additional focus notes or guidance' })
  @IsOptional()
  @IsString()
  notes?: string;
}
