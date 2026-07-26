import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum } from 'class-validator';
import { ReviewFrequency } from '../constants/finance-ai-enums.constants';

export class FinancialReviewRequestDto {
  @ApiPropertyOptional({ description: 'Review period frequency', enum: ReviewFrequency, default: ReviewFrequency.MONTHLY })
  @IsOptional()
  @IsEnum(ReviewFrequency)
  frequency?: ReviewFrequency = ReviewFrequency.MONTHLY;
}
