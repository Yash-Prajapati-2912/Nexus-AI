import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsDateString,
  IsEnum,
  IsOptional,
  IsBoolean,
} from 'class-validator';
import { IncomeFrequency } from '../constants/finance-enums.constants';

export class CreateIncomeDto {
  @ApiProperty({ description: 'Source of income', example: 'Campus Library Assistant' })
  @IsString()
  @IsNotEmpty()
  source: string;

  @ApiProperty({ description: 'Income amount', example: 450.0 })
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  amount: number;

  @ApiPropertyOptional({ description: 'Recurrence frequency', enum: IncomeFrequency, default: IncomeFrequency.MONTHLY })
  @IsOptional()
  @IsEnum(IncomeFrequency)
  frequency?: IncomeFrequency;

  @ApiProperty({ description: 'Date income received (ISO string)', example: '2026-09-01T09:00:00Z' })
  @IsDateString()
  receivedDate: string;

  @ApiPropertyOptional({ description: 'Income notes or description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ description: 'Is recurring income source', default: false })
  @IsOptional()
  @IsBoolean()
  isRecurring?: boolean;
}
