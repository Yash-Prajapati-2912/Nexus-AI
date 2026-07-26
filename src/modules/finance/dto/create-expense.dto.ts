import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsUUID,
  IsDateString,
  IsEnum,
  IsOptional,
  IsBoolean,
  IsArray,
  IsUrl,
} from 'class-validator';
import { PaymentMethod } from '../constants/finance-enums.constants';

export class CreateExpenseDto {
  @ApiProperty({ description: 'Category UUID' })
  @IsUUID()
  @IsNotEmpty()
  categoryId: string;

  @ApiPropertyOptional({ description: 'Budget UUID to associate this expense with' })
  @IsOptional()
  @IsUUID()
  budgetId?: string;

  @ApiProperty({ description: 'Expense title / summary', example: 'Campus Library Printing' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiPropertyOptional({ description: 'Detailed description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ description: 'Transaction amount', example: 12.5 })
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  amount: number;

  @ApiProperty({ description: 'Date and time of expense (ISO Date String)', example: '2026-09-15T14:30:00Z' })
  @IsDateString()
  expenseDate: string;

  @ApiPropertyOptional({ description: 'Payment method', enum: PaymentMethod, default: PaymentMethod.DEBIT_CARD })
  @IsOptional()
  @IsEnum(PaymentMethod)
  paymentMethod?: PaymentMethod;

  @ApiPropertyOptional({ description: 'Merchant / Payee name', example: 'University Bookstore' })
  @IsOptional()
  @IsString()
  merchant?: string;

  @ApiPropertyOptional({ description: 'Physical or online location', example: 'Student Union Bldg 2' })
  @IsOptional()
  @IsString()
  location?: string;

  @ApiPropertyOptional({ description: 'Receipt document/image URL' })
  @IsOptional()
  @IsUrl()
  receiptUrl?: string;

  @ApiPropertyOptional({ description: 'Recurring expense indicator', default: false })
  @IsOptional()
  @IsBoolean()
  isRecurring?: boolean;

  @ApiPropertyOptional({ description: 'Tags array for categorization', example: ['academics', 'essentials'] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @ApiPropertyOptional({ description: 'Private notes' })
  @IsOptional()
  @IsString()
  notes?: string;
}
