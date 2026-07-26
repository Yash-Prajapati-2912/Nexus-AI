import { ApiProperty } from '@nestjs/swagger';

export class DecomposedMilestoneDto {
  @ApiProperty({ description: 'Step index number' })
  step: number;

  @ApiProperty({ description: 'Milestone title' })
  title: string;

  @ApiProperty({ description: 'Milestone description' })
  description: string;

  @ApiProperty({ description: 'Estimated timeframe in days' })
  estimatedDays: number;
}

export class GoalPlanResponseDto {
  @ApiProperty({ description: 'Goal title' })
  goalTitle: string;

  @ApiProperty({ description: 'Decomposed SMART milestones', type: [DecomposedMilestoneDto] })
  decomposedMilestones: DecomposedMilestoneDto[];

  @ApiProperty({ description: 'Identified execution risks', type: [String] })
  identifiedRisks: string[];

  @ApiProperty({ description: 'Probability of achieving goal (0 - 100%)' })
  successProbability: number;

  @ApiProperty({ description: 'Goal priority score' })
  priorityScore: number;
}
