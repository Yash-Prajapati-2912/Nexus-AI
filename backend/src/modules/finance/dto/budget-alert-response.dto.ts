import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AlertType } from '../constants/analytics-enums.constants';

export class BudgetAlertResponseDto {
  @ApiProperty({ description: 'Alert UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID owner' })
  userId: string;

  @ApiPropertyOptional({ description: 'Budget UUID if budget alert' })
  budgetId?: string | null;

  @ApiPropertyOptional({ description: 'Savings Goal UUID if savings goal alert' })
  savingsGoalId?: string | null;

  @ApiProperty({ description: 'Alert trigger type', enum: AlertType })
  alertType: AlertType;

  @ApiProperty({ description: 'Percentage threshold reached' })
  thresholdPercentage: number;

  @ApiProperty({ description: 'Alert message' })
  message: string;

  @ApiProperty({ description: 'Read indicator flag' })
  isRead: boolean;

  @ApiProperty({ description: 'Trigger timestamp ISO string' })
  triggeredAt: Date;
}
