import { ApiProperty } from '@nestjs/swagger';
import { ReadinessLevel } from '../constants/intelligence-enums.constants';

export class MilestoneDto {
  @ApiProperty({ description: 'Milestone title' })
  title: string;

  @ApiProperty({ description: 'Detailed milestone guidance' })
  description: string;

  @ApiProperty({ description: 'Target timeframe in days', example: 30 })
  targetDays: number;
}

export class CareerRoadmapResponseDto {
  @ApiProperty({ description: 'Target role name' })
  targetRole: string;

  @ApiProperty({ description: 'Detected skill gaps', type: [String] })
  skillGaps: string[];

  @ApiProperty({ description: 'Readiness score (0 - 100)' })
  readinessScore: number;

  @ApiProperty({ description: 'Readiness level', enum: ReadinessLevel })
  readinessLevel: ReadinessLevel;

  @ApiProperty({ description: 'Resume improvement suggestions', type: [String] })
  resumeSuggestions: string[];

  @ApiProperty({ description: 'Portfolio project recommendations', type: [String] })
  portfolioRecommendations: string[];

  @ApiProperty({ description: 'Certification suggestions', type: [String] })
  certificationSuggestions: string[];

  @ApiProperty({ description: 'Ordered milestone timeline', type: [MilestoneDto] })
  milestones: MilestoneDto[];
}
