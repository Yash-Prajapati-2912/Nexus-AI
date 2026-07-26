import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IncomeFrequency } from '../constants/finance-enums.constants';

export class IncomeResponseDto {
  @ApiProperty({ description: 'Income UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Income source title' })
  source: string;

  @ApiProperty({ description: 'Income amount' })
  amount: number;

  @ApiProperty({ description: 'Frequency', enum: IncomeFrequency })
  frequency: IncomeFrequency;

  @ApiProperty({ description: 'Received Date UTC ISO string' })
  receivedDate: Date;

  @ApiPropertyOptional({ description: 'Description' })
  description?: string | null;

  @ApiProperty({ description: 'Is Recurring flag' })
  isRecurring: boolean;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update ISO timestamp' })
  updatedAt: Date;
}
