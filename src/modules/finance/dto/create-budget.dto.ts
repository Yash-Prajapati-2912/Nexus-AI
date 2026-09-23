import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsNumber,
  IsPositive,
  IsString,
  IsOptional,
  Length,
} from 'class-validator';
import { IsValidMonth } from '../validators/is-valid-month.validator';
import { IsValidYear } from '../validators/is-valid-year.validator';

export class CreateBudgetDto {
  @ApiProperty({ description: 'Target calendar month (1-12)', example: 9 })
  @IsValidMonth()
  month: number;

  @ApiProperty({ description: 'Target 4-digit calendar year', example: 2026 })
  @IsValidYear()
  year: number;

  @ApiProperty({ description: 'Total planned budget amount', example: 1500.0 })
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  plannedAmount: number;

  @ApiPropertyOptional({ description: 'Currency code ISO-4217', example: 'INR', default: 'INR' })
  @IsOptional()
  @IsString()
  @Length(3, 3)
  currency?: string;

  @ApiPropertyOptional({ description: 'Notes or goals for this monthly budget' })
  @IsOptional()
  @IsString()
  notes?: string;
}
