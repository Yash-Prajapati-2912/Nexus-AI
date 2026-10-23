import { ApiProperty } from '@nestjs/swagger';
import { CategoryBreakdownDto } from './monthly-summary-response.dto';
import { ExpenseResponseDto } from './expense-response.dto';

export class BudgetWidgetDto {
  @ApiProperty({ description: 'Planned budget amount' })
  planned: number;

  @ApiProperty({ description: 'Spent budget amount' })
  spent: number;

  @ApiProperty({ description: 'Remaining budget amount' })
  remaining: number;

  @ApiProperty({ description: 'Percentage utilised' })
  utilisationPercentage: number;
}

export class SavingsWidgetDto {
  @ApiProperty({ description: 'Total accumulated savings' })
  totalSavings: number;

  @ApiProperty({ description: 'Active savings goals count' })
  activeGoalsCount: number;

  @ApiProperty({ description: 'Completed savings goals count' })
  completedGoalsCount: number;
}

export class DashboardWidgetsResponseDto {
  @ApiProperty({ description: 'Budget summary widget', type: BudgetWidgetDto })
  budgetWidget: BudgetWidgetDto;

  @ApiProperty({ description: 'Total monthly income' })
  monthlyIncome: number;

  @ApiProperty({ description: 'Total monthly expenses' })
  monthlyExpenses: number;

  @ApiProperty({ description: 'Net monthly cash flow' })
  netCashFlow: number;

  @ApiProperty({ description: 'Savings summary widget', type: SavingsWidgetDto })
  savingsWidget: SavingsWidgetDto;

  @ApiProperty({ description: 'Top spending categories widget', type: [CategoryBreakdownDto] })
  topCategoriesWidget: CategoryBreakdownDto[];

  @ApiProperty({ description: 'Recent transactions widget', type: [ExpenseResponseDto] })
  recentExpensesWidget: ExpenseResponseDto[];
}
