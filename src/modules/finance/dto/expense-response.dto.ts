import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PaymentMethod } from '../constants/finance-enums.constants';
import { ExpenseCategoryResponseDto } from './expense-category-response.dto';

export class ExpenseResponseDto {
  @ApiProperty({ description: 'Expense UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiPropertyOptional({ description: 'Associated Budget UUID' })
  budgetId?: string | null;

  @ApiProperty({ description: 'Category UUID' })
  categoryId: string;

  @ApiPropertyOptional({ description: 'Joined Category Details', type: () => ExpenseCategoryResponseDto })
  category?: ExpenseCategoryResponseDto;

  @ApiProperty({ description: 'Title' })
  title: string;

  @ApiPropertyOptional({ description: 'Description' })
  description?: string | null;

  @ApiProperty({ description: 'Amount' })
  amount: number;

  @ApiProperty({ description: 'Expense Date UTC ISO string' })
  expenseDate: Date;

  @ApiProperty({ description: 'Payment Method', enum: PaymentMethod })
  paymentMethod: PaymentMethod;

  @ApiPropertyOptional({ description: 'Merchant name' })
  merchant?: string | null;

  @ApiPropertyOptional({ description: 'Location' })
  location?: string | null;

  @ApiPropertyOptional({ description: 'Receipt CDN URL' })
  receiptUrl?: string | null;

  @ApiProperty({ description: 'Is Recurring flag' })
  isRecurring: boolean;

  @ApiPropertyOptional({ description: 'Tags array', type: [String] })
  tags?: string[] | null;

  @ApiPropertyOptional({ description: 'Notes' })
  notes?: string | null;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update ISO timestamp' })
  updatedAt: Date;
}
