import { ApiProperty } from '@nestjs/swagger';

export class TrendPointDto {
  @ApiProperty({ description: 'Period label (e.g. 2026-09 or 2026-W37)' })
  periodLabel: string;

  @ApiProperty({ description: 'Income growth percentage' })
  incomeGrowthPercentage: number;

  @ApiProperty({ description: 'Expense growth percentage' })
  expenseGrowthPercentage: number;

  @ApiProperty({ description: 'Savings growth percentage' })
  savingsGrowthPercentage: number;

  @ApiProperty({ description: 'Budget consumption rate' })
  budgetConsumptionRate: number;

  @ApiProperty({ description: 'Net cash flow' })
  netCashFlow: number;
}

export class TrendResponseDto {
  @ApiProperty({ description: 'Trend period type', example: 'MONTHLY' })
  periodType: string;

  @ApiProperty({ description: 'Historical trend data points', type: [TrendPointDto] })
  trends: TrendPointDto[];
}
