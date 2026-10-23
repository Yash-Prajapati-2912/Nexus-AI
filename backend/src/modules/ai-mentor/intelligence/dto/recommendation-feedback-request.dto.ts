import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID, IsBoolean, IsOptional, IsEnum, IsString } from 'class-validator';
import { FeedbackRating } from '../constants/intelligence-enums.constants';

export class RecommendationFeedbackRequestDto {
  @ApiProperty({ description: 'Target recommendation UUID' })
  @IsNotEmpty()
  @IsUUID()
  recommendationId: string;

  @ApiProperty({ description: 'Rating score (1 to 5)', enum: FeedbackRating, example: 5 })
  @IsNotEmpty()
  @IsEnum(FeedbackRating)
  ratingScore: FeedbackRating;

  @ApiProperty({ description: 'Is recommendation helpful?' })
  @IsNotEmpty()
  @IsBoolean()
  isHelpful: boolean;

  @ApiPropertyOptional({ description: 'Feedback comments' })
  @IsOptional()
  @IsString()
  comments?: string;
}
