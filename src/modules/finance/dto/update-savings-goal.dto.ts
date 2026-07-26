import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsPositive,
  IsDateString,
  IsEnum,
  IsOptional,
  Min,
} from 'class-validator';
import { SavingsPriority, SavingsStatus } from '../constants/finance-enums.constants';

export class UpdateSavingsGoalDto {
  @ApiPropertyOptional({ description: 'Savings target title' })
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional({ description: 'Target monetary amount' })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  targetAmount?: number;

  @ApiPropertyOptional({ description: 'Current saved amount' })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  currentAmount?: number;

  @ApiPropertyOptional({ description: 'Target deadline date ISO string' })
  @IsOptional()
  @IsDateString()
  targetDate?: string;

  @ApiPropertyOptional({ description: 'Goal priority', enum: SavingsPriority })
  @IsOptional()
  @IsEnum(SavingsPriority)
  priority?: SavingsPriority;

  @ApiPropertyOptional({ description: 'Goal status', enum: SavingsStatus })
  @IsOptional()
  @IsEnum(SavingsStatus)
  status?: SavingsStatus;

  @ApiPropertyOptional({ description: 'Goal description' })
  @IsOptional()
  @IsString()
  description?: string;
}
