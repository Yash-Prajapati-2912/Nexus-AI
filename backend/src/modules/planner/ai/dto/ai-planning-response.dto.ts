import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RecommendationDto {
  @ApiProperty({ example: 'Schedule Focus Study Block' })
  title: string;

  @ApiProperty({ example: 'Allocate 90 minutes of uninterruptible focus time.' })
  description: string;

  @ApiProperty({ example: 'HIGH' })
  priority: string;

  @ApiPropertyOptional({ example: 'RESOURCE' })
  type?: string;

  @ApiPropertyOptional({ example: 'https://docs.example.com' })
  linkUrl?: string;
}

export class ActionItemDto {
  @ApiProperty({ example: 1 })
  step: number;

  @ApiProperty({ example: 'Complete urgent assignment draft' })
  title: string;

  @ApiPropertyOptional({ example: 60 })
  allocatedMinutes?: number;

  @ApiPropertyOptional({ example: '2026-07-28' })
  targetDate?: string;
}

export class AIPlanningResponseDto {
  @ApiProperty({ example: 'res123-uuid' })
  id: string;

  @ApiProperty({ example: 'PRIORITISE_TASKS' })
  actionType: string;

  @ApiProperty({ example: 'Analyzed active tasks and prioritized high-risk items.' })
  summary: string;

  @ApiProperty({ example: ['Prioritized assignment due tomorrow.'] })
  reasoning: string[];

  @ApiProperty({ type: [RecommendationDto] })
  recommendations: RecommendationDto[];

  @ApiProperty({ type: [ActionItemDto] })
  actionItems: ActionItemDto[];

  @ApiProperty({ example: ['Workload is high today.'] })
  warnings: string[];

  @ApiProperty({ example: 0.95 })
  confidenceScore: number;

  @ApiProperty({ example: 'GEMINI' })
  providerName: string;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;
}
