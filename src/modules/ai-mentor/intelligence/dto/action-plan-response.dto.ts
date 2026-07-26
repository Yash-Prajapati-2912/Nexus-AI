import { ApiProperty } from '@nestjs/swagger';
import { DifficultyLevel } from '../constants/intelligence-enums.constants';

export class ActionPlanStepDto {
  @ApiProperty({ description: 'Step index number' })
  step: number;

  @ApiProperty({ description: 'Step title' })
  title: string;

  @ApiProperty({ description: 'Step description' })
  description: string;
}

export class ActionPlanResponseDto {
  @ApiProperty({ description: 'Plan title' })
  title: string;

  @ApiProperty({ description: 'Plan summary' })
  summary: string;

  @ApiProperty({ description: 'Plan reasoning' })
  reasoning: string;

  @ApiProperty({ description: 'Expected benefits', type: [String] })
  benefits: string[];

  @ApiProperty({ description: 'Potential risks', type: [String] })
  potentialRisks: string[];

  @ApiProperty({ description: 'Action steps', type: [ActionPlanStepDto] })
  actionSteps: ActionPlanStepDto[];

  @ApiProperty({ description: 'Estimated execution time in minutes' })
  estimatedTimeMinutes: number;

  @ApiProperty({ description: 'Difficulty level', enum: DifficultyLevel })
  difficultyLevel: DifficultyLevel;

  @ApiProperty({ description: 'Priority level', example: 'HIGH' })
  priority: string;

  @ApiProperty({ description: 'Confidence score' })
  confidenceScore: number;

  @ApiProperty({ description: 'Expected outcome' })
  expectedOutcome: string;
}
