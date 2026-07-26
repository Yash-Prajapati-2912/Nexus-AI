import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsDateString,
  IsEnum,
  IsOptional,
  Min,
} from 'class-validator';
import { SavingsPriority } from '../constants/finance-enums.constants';

export class CreateSavingsGoalDto {
  @ApiProperty({ description: 'Savings target title', example: 'New Engineering Laptop' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ description: 'Target monetary amount', example: 1200.0 })
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  targetAmount: number;

  @ApiPropertyOptional({ description: 'Initial current saved amount', example: 150.0, default: 0 })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  currentAmount?: number;

  @ApiProperty({ description: 'Target deadline date ISO string', example: '2026-12-31T23:59:59Z' })
  @IsDateString()
  targetDate: string;

  @ApiPropertyOptional({ description: 'Goal priority', enum: SavingsPriority, default: SavingsPriority.MEDIUM })
  @IsOptional()
  @IsEnum(SavingsPriority)
  priority?: SavingsPriority;

  @ApiPropertyOptional({ description: 'Goal description or details' })
  @IsOptional()
  @IsString()
  description?: string;
}
