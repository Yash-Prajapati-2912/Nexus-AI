import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsInt, Min, Max } from 'class-validator';
import { Transform } from 'class-transformer';
import { AIProviderType } from '../constants/finance-ai-enums.constants';

export class MonthEndPredictionRequestDto {
  @ApiPropertyOptional({ description: 'Target month (1-12)' })
  @IsOptional()
  @Transform(({ value }) => parseInt(value, 10))
  @IsInt()
  @Min(1)
  @Max(12)
  month?: number;

  @ApiPropertyOptional({ description: 'Target year' })
  @IsOptional()
  @Transform(({ value }) => parseInt(value, 10))
  @IsInt()
  @Min(2000)
  @Max(2100)
  year?: number;

  @ApiPropertyOptional({ description: 'AI Provider override', enum: AIProviderType })
  @IsOptional()
  @IsEnum(AIProviderType)
  provider?: AIProviderType;
}
