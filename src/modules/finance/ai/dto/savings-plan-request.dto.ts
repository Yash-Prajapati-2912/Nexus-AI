import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsNumber, Min } from 'class-validator';
import { Transform } from 'class-transformer';

export class SavingsPlanRequestDto {
  @ApiPropertyOptional({ description: 'Target monthly savings goal contribution', example: 100.0 })
  @IsOptional()
  @Transform(({ value }) => parseFloat(value))
  @IsNumber()
  @Min(1)
  targetMonthlySavings?: number;
}
