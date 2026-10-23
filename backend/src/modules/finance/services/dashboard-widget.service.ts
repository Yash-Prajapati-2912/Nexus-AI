import { Injectable, Logger } from '@nestjs/common';
import { BudgetRepository } from '../repositories/budget.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { IncomeRepository } from '../repositories/income.repository';
import { SavingsGoalRepository } from '../repositories/savings-goal.repository';
import { FinanceMapper } from '../mappers/finance.mapper';
import {
  DashboardWidgetsResponseDto,
  BudgetWidgetDto,
  SavingsWidgetDto,
} from '../dto/dashboard-widget-response.dto';
import { CategoryBreakdownDto } from '../dto/monthly-summary-response.dto';
import { ExpenseResponseDto } from '../dto/expense-response.dto';
import { SavingsStatus } from '../constants/finance-enums.constants';

@Injectable()
export class DashboardWidgetService {
  private readonly logger = new Logger(DashboardWidgetService.name);

  constructor(
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly savingsGoalRepository: SavingsGoalRepository,
  ) {}

  async getBudgetSummaryWidget(userId: string): Promise<BudgetWidgetDto> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const budget = await this.budgetRepository.findByUserAndPeriod(userId, month, year);
    if (!budget) {
      return { planned: 0, spent: 0, remaining: 0, utilisationPercentage: 0 };
    }

    const planned = Number(budget.plannedAmount);
    const spent = Number(budget.spentAmount);
    const remaining = Number(budget.remainingAmount);
    const utilisationPercentage = planned > 0 ? parseFloat(((spent / planned) * 100).toFixed(2)) : 0;

    return { planned, spent, remaining, utilisationPercentage };
  }

  async getSavingsWidget(userId: string): Promise<SavingsWidgetDto> {
    const goals = await this.savingsGoalRepository.findUserSavingsGoals(userId);
    const totalSavings = goals.reduce((sum, g) => sum + Number(g.currentAmount), 0);
    const activeGoalsCount = goals.filter((g) => g.status === SavingsStatus.IN_PROGRESS).length;
    const completedGoalsCount = goals.filter((g) => g.status === SavingsStatus.COMPLETED).length;

    return {
      totalSavings: parseFloat(totalSavings.toFixed(2)),
      activeGoalsCount,
      completedGoalsCount,
    };
  }

  async getDashboardWidgets(userId: string): Promise<DashboardWidgetsResponseDto> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const [budgetWidget, savingsWidget, monthlyExpenses, monthlyIncome, categoryBreakdown, recentExpenses] =
      await Promise.all([
        this.getBudgetSummaryWidget(userId),
        this.getSavingsWidget(userId),
        this.expenseRepository.calculateTotalSpentForPeriod(userId, month, year),
        this.incomeRepository.calculateTotalIncomeForPeriod(userId, month, year),
        this.expenseRepository.getCategoryBreakdownForPeriod(userId, month, year),
        this.expenseRepository.findMany({
          where: { userId },
          relations: ['category'],
          order: { expenseDate: 'DESC' },
          take: 5,
        }),
      ]);

    const netCashFlow = parseFloat((monthlyIncome - monthlyExpenses).toFixed(2));

    const topCategoriesWidget: CategoryBreakdownDto[] = categoryBreakdown.slice(0, 5).map((c) => ({
      categoryId: c.categoryId,
      categoryName: c.categoryName,
      colour: c.colour,
      icon: c.icon,
      totalAmount: c.totalAmount,
      percentage: c.percentage,
    }));

    const recentExpensesWidget: ExpenseResponseDto[] = recentExpenses.map(FinanceMapper.toExpenseDto);

    return {
      budgetWidget,
      monthlyIncome: parseFloat(monthlyIncome.toFixed(2)),
      monthlyExpenses: parseFloat(monthlyExpenses.toFixed(2)),
      netCashFlow,
      savingsWidget,
      topCategoriesWidget,
      recentExpensesWidget,
    };
  }
}
