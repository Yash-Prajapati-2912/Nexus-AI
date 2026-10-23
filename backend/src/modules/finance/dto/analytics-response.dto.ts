import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CategoryBreakdownDto } from './monthly-summary-response.dto';

export class FinancialMetricDto {
  @ApiProperty({ description: 'Metric key identifier' })
  metricKey: string;

  @ApiProperty({ description: 'Calculated metric value' })
  metricValue: string;

  @ApiProperty({ description: 'Calculation timestamp' })
  calculatedAt: Date;
}

export class AnalyticsOverviewDto {
  @ApiProperty({ description: 'Total income accumulated' })
  totalIncome: number;

  @ApiProperty({ description: 'Total expenses incurred' })
  totalExpenses: number;

  @ApiProperty({ description: 'Net balance (Income - Expenses)' })
  netBalance: number;

  @ApiProperty({ description: 'Savings rate percentage' })
  savingsRate: number;

  @ApiProperty({ description: 'Average daily spending' })
  avgDailySpending: number;

  @ApiProperty({ description: 'Median spending per expense' })
  medianSpending: number;

  @ApiProperty({ description: 'Highest single transaction amount' })
  highestExpense: number;

  @ApiProperty({ description: 'Lowest single transaction amount' })
  lowestExpense: number;

  @ApiProperty({ description: 'Planned budget for period' })
  plannedBudget: number;

  @ApiProperty({ description: 'Remaining budget balance' })
  remainingBudget: number;

  @ApiProperty({ description: 'Budget utilisation percentage' })
  budgetUtilisation: number;
}

export class FinancialAnalyticsResponseDto {
  @ApiProperty({ description: 'Overview statistics', type: AnalyticsOverviewDto })
  overview: AnalyticsOverviewDto;

  @ApiProperty({ description: 'Category distribution breakdown', type: [CategoryBreakdownDto] })
  categoryDistribution: CategoryBreakdownDto[];

  @ApiProperty({ description: 'Calculated key financial metrics', type: [FinancialMetricDto] })
  metrics: FinancialMetricDto[];
}
