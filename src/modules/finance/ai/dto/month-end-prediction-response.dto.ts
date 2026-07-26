import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class MonthEndPredictionResponseDto {
  @ApiProperty({ description: 'Predicted month-end remaining balance' })
  predictedMonthEndBalance: number;

  @ApiProperty({ description: 'Expected total spending by month end' })
  expectedTotalSpending: number;

  @ApiProperty({ description: 'Probability of achieving savings target (0 - 100%)' })
  savingsAchievementProbability: number;

  @ApiPropertyOptional({ description: 'Projected budget exhaustion date (ISO YYYY-MM-DD)' })
  budgetExhaustionDate?: string | null;

  @ApiProperty({ description: 'Mathematical & AI reasoning breakdown' })
  reasoning: string;

  @ApiProperty({ description: 'Model confidence score' })
  confidenceScore: number;
}
