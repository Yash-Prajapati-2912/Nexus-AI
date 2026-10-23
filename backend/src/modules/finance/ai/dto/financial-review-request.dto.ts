import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsString } from 'class-validator';
import { ReviewFrequency } from '../constants/finance-ai-enums.constants';

export class FinancialReviewRequestDto {
  @ApiPropertyOptional({ description: 'Review period frequency', enum: ReviewFrequency, default: ReviewFrequency.MONTHLY })
  @IsOptional()
  @IsEnum(ReviewFrequency)
  frequency?: ReviewFrequency = ReviewFrequency.MONTHLY;

  @ApiPropertyOptional({ description: 'Specific review focus type (e.g. SUBSCRIPTIONS, GOALS)', example: 'SUBSCRIPTIONS' })
  @IsOptional()
  @IsString()
  reviewType?: string;
}
