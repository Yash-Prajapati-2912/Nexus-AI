import { ApiProperty } from '@nestjs/swagger';
import { IsValidMonth } from '../validators/is-valid-month.validator';
import { IsValidYear } from '../validators/is-valid-year.validator';

export class DuplicateBudgetDto {
  @ApiProperty({ description: 'Target month to copy budget into (1-12)', example: 10 })
  @IsValidMonth()
  targetMonth: number;

  @ApiProperty({ description: 'Target 4-digit year to copy budget into', example: 2026 })
  @IsValidYear()
  targetYear: number;
}
