import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { BudgetStatus } from '../constants/finance-enums.constants';

export class BudgetResponseDto {
  @ApiProperty({ description: 'Budget UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID owner' })
  userId: string;

  @ApiProperty({ description: 'Calendar Month (1-12)' })
  month: number;

  @ApiProperty({ description: 'Calendar Year' })
  year: number;

  @ApiProperty({ description: 'Planned total allocation' })
  plannedAmount: number;

  @ApiProperty({ description: 'Spent amount to date' })
  spentAmount: number;

  @ApiProperty({ description: 'Remaining budget balance' })
  remainingAmount: number;

  @ApiProperty({ description: 'ISO 4217 Currency Code' })
  currency: string;

  @ApiProperty({ description: 'Operational Status', enum: BudgetStatus })
  status: BudgetStatus;

  @ApiPropertyOptional({ description: 'Optional budget notes' })
  notes?: string | null;

  @ApiProperty({ description: 'Creation UTC ISO timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update UTC ISO timestamp' })
  updatedAt: Date;
}
