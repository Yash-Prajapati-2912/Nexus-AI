import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RecommendationItemDto {
  @ApiProperty({ description: 'Recommendation title' })
  title: string;

  @ApiProperty({ description: 'Detailed recommendation description' })
  description: string;

  @ApiProperty({ description: 'Priority level', example: 'HIGH' })
  priority: string;

  @ApiPropertyOptional({ description: 'Target spending category' })
  category?: string;

  @ApiPropertyOptional({ description: 'Potential monthly savings' })
  potentialSavings?: number;
}

export class AIAnalysisResponseDto {
  @ApiProperty({ description: 'Executive Summary' })
  summary: string;

  @ApiProperty({ description: 'Financial Strengths', type: [String] })
  strengths: string[];

  @ApiProperty({ description: 'Financial Weaknesses', type: [String] })
  weaknesses: string[];

  @ApiProperty({ description: 'Actionable Recommendations', type: [RecommendationItemDto] })
  recommendations: RecommendationItemDto[];

  @ApiProperty({ description: 'Overspending & Risk Warnings', type: [String] })
  warnings: string[];

  @ApiProperty({ description: 'AI Model Confidence Score (0 - 1)' })
  confidenceScore: number;

  @ApiProperty({ description: 'Active Provider Name' })
  providerName: string;
}
