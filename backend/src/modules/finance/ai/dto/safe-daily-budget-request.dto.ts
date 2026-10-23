import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsNumber, Min } from 'class-validator';
import { Transform } from 'class-transformer';

export class SafeDailyBudgetRequestDto {
  @ApiPropertyOptional({ description: 'Optional planned upcoming expenditure to reserve', example: 100.0 })
  @IsOptional()
  @Transform(({ value }) => parseFloat(value))
  @IsNumber()
  @Min(0)
  upcomingExpensesReserve?: number = 0;
}
