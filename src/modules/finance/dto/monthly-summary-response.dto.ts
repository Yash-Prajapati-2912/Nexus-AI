import { ApiProperty } from '@nestjs/swagger';
import { ICategoryBreakdown } from '../interfaces/category-breakdown.interface';

export class CategoryBreakdownDto implements ICategoryBreakdown {
  @ApiProperty({ description: 'Category UUID' })
  categoryId: string;

  @ApiProperty({ description: 'Category name' })
  categoryName: string;

  @ApiProperty({ description: 'Category Hex color' })
  colour: string;

  @ApiProperty({ description: 'Category icon' })
  icon: string;

  @ApiProperty({ description: 'Total spending in category' })
  totalAmount: number;

  @ApiProperty({ description: 'Percentage of total expenses' })
  percentage: number;
}

export class MonthlySummaryResponseDto {
  @ApiProperty({ description: 'Summary UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Calendar Month (1-12)' })
  month: number;

  @ApiProperty({ description: 'Calendar Year' })
  year: number;

  @ApiProperty({ description: 'Total Monthly Income' })
  totalIncome: number;

  @ApiProperty({ description: 'Total Monthly Expenses' })
  totalExpenses: number;

  @ApiProperty({ description: 'Remaining Budget Balance' })
  remainingBudget: number;

  @ApiProperty({ description: 'Net Monthly Savings (Total Income - Total Expenses)' })
  savings: number;

  @ApiProperty({ description: 'Average Daily Expenditure' })
  averageDailySpending: number;

  @ApiProperty({ description: 'Top Spending Categories Breakdown', type: [CategoryBreakdownDto] })
  topCategories: CategoryBreakdownDto[];

  @ApiProperty({ description: 'Budget Utilisation Percentage (0 - 100% or higher if exceeded)' })
  budgetUtilisationPercentage: number;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update ISO timestamp' })
  updatedAt: Date;
}
