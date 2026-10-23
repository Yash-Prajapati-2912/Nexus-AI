import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsNumber, IsPositive, IsString, IsOptional, Length, IsEnum } from 'class-validator';
import { BudgetStatus } from '../constants/finance-enums.constants';

export class UpdateBudgetDto {
  @ApiPropertyOptional({ description: 'Updated planned budget amount', example: 1800.0 })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  plannedAmount?: number;

  @ApiPropertyOptional({ description: 'Currency code ISO-4217', example: 'USD' })
  @IsOptional()
  @IsString()
  @Length(3, 3)
  currency?: string;

  @ApiPropertyOptional({ description: 'Budget status', enum: BudgetStatus })
  @IsOptional()
  @IsEnum(BudgetStatus)
  status?: BudgetStatus;

  @ApiPropertyOptional({ description: 'Updated budget notes' })
  @IsOptional()
  @IsString()
  notes?: string;
}
