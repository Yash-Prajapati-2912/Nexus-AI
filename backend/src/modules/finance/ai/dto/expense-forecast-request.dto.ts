import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsInt, Min, Max } from 'class-validator';
import { Transform } from 'class-transformer';

export class ExpenseForecastRequestDto {
  @ApiPropertyOptional({ description: 'Forecast horizon in days (e.g. 30, 60, 90)', default: 30 })
  @IsOptional()
  @Transform(({ value }) => parseInt(value, 10))
  @IsInt()
  @Min(7)
  @Max(365)
  daysAhead?: number = 30;
}
