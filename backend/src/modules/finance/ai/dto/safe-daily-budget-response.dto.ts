import { ApiProperty } from '@nestjs/swagger';

export class SafeDailyBudgetResponseDto {
  @ApiProperty({ description: 'Calculated safe daily spending limit' })
  safeDailyLimit: number;

  @ApiProperty({ description: 'Remaining budget balance' })
  remainingBudget: number;

  @ApiProperty({ description: 'Remaining days in month' })
  remainingDays: number;

  @ApiProperty({ description: 'Reserved savings allocation' })
  reservedSavings: number;

  @ApiProperty({ description: 'Planned upcoming expenses reserve' })
  plannedUpcomingExpenses: number;

  @ApiProperty({ description: 'Explicit mathematical equation & reasoning' })
  mathematicalReasoning: string;

  @ApiProperty({ description: 'Behavioral guidance recommendations', type: [String] })
  behavioralGuidance: string[];

  @ApiProperty({ description: 'Confidence score' })
  confidenceScore: number;
}
