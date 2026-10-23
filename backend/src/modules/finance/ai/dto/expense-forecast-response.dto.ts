import { ApiProperty } from '@nestjs/swagger';

export class ForecastItemDto {
  @ApiProperty({ description: 'Forecasted expense item title' })
  title: string;

  @ApiProperty({ description: 'Category name' })
  categoryName: string;

  @ApiProperty({ description: 'Forecasted amount' })
  forecastedAmount: number;

  @ApiProperty({ description: 'Projected forecast date (YYYY-MM-DD)' })
  forecastDate: string;

  @ApiProperty({ description: 'Confidence score' })
  confidence: number;
}

export class ExpenseForecastResponseDto {
  @ApiProperty({ description: 'Array of forecasted expense items', type: [ForecastItemDto] })
  forecastedItems: ForecastItemDto[];

  @ApiProperty({ description: 'Total forecasted expense amount' })
  totalForecastedAmount: number;

  @ApiProperty({ description: 'Executive summary' })
  summary: string;

  @ApiProperty({ description: 'Model confidence score' })
  confidenceScore: number;
}
