import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsPositive,
  IsDateString,
  IsEnum,
  IsOptional,
  IsBoolean,
} from 'class-validator';
import { IncomeFrequency } from '../constants/finance-enums.constants';

export class UpdateIncomeDto {
  @ApiPropertyOptional({ description: 'Source of income' })
  @IsOptional()
  @IsString()
  source?: string;

  @ApiPropertyOptional({ description: 'Income amount' })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  amount?: number;

  @ApiPropertyOptional({ description: 'Recurrence frequency', enum: IncomeFrequency })
  @IsOptional()
  @IsEnum(IncomeFrequency)
  frequency?: IncomeFrequency;

  @ApiPropertyOptional({ description: 'Date income received' })
  @IsOptional()
  @IsDateString()
  receivedDate?: string;

  @ApiPropertyOptional({ description: 'Income description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ description: 'Is recurring flag' })
  @IsOptional()
  @IsBoolean()
  isRecurring?: boolean;
}
