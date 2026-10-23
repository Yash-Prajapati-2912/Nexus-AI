import { ApiProperty } from '@nestjs/swagger';

export class DailyCashFlowPointDto {
  @ApiProperty({ description: 'Date ISO label (YYYY-MM-DD)' })
  date: string;

  @ApiProperty({ description: 'Total inflow amount on date' })
  inflow: number;

  @ApiProperty({ description: 'Total outflow amount on date' })
  outflow: number;

  @ApiProperty({ description: 'Net cash flow balance on date' })
  net: number;
}

export class CashFlowResponseDto {
  @ApiProperty({ description: 'Start date ISO string' })
  startDate: Date;

  @ApiProperty({ description: 'End date ISO string' })
  endDate: Date;

  @ApiProperty({ description: 'Total money received (Inflow)' })
  totalInflow: number;

  @ApiProperty({ description: 'Total money spent (Outflow)' })
  totalOutflow: number;

  @ApiProperty({ description: 'Net Cash Flow (Inflow - Outflow)' })
  netCashFlow: number;

  @ApiProperty({ description: 'Average daily inflow' })
  dailyAverageInflow: number;

  @ApiProperty({ description: 'Average daily outflow' })
  dailyAverageOutflow: number;

  @ApiProperty({ description: 'Projected balance at end of period' })
  projectedEndBalance: number;

  @ApiProperty({ description: 'Daily breakdown points array', type: [DailyCashFlowPointDto] })
  dailyBreakdown: DailyCashFlowPointDto[];
}
