import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SavingsPriority, SavingsStatus } from '../constants/finance-enums.constants';

export class SavingsGoalResponseDto {
  @ApiProperty({ description: 'Savings Goal UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID owner' })
  userId: string;

  @ApiProperty({ description: 'Goal title' })
  title: string;

  @ApiProperty({ description: 'Target amount' })
  targetAmount: number;

  @ApiProperty({ description: 'Current saved amount' })
  currentAmount: number;

  @ApiProperty({ description: 'Progress percentage (0 - 100%)' })
  progressPercentage: number;

  @ApiProperty({ description: 'Target deadline UTC ISO string' })
  targetDate: Date;

  @ApiProperty({ description: 'Priority level', enum: SavingsPriority })
  priority: SavingsPriority;

  @ApiProperty({ description: 'Goal status', enum: SavingsStatus })
  status: SavingsStatus;

  @ApiPropertyOptional({ description: 'Goal description' })
  description?: string | null;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update ISO timestamp' })
  updatedAt: Date;
}
