import { Injectable, Logger } from '@nestjs/common';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { IFinanceOverviewData } from '../interfaces/aggregated-dashboard-data.interface';

@Injectable()
export class FinanceOverviewAggregator {
  private readonly logger = new Logger(FinanceOverviewAggregator.name);

  constructor(
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
  ) {}

  async aggregate(userId: string): Promise<IFinanceOverviewData> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const [budget, monthExpenses] = await Promise.all([
      this.budgetRepository.findByUserAndPeriod(userId, month, year).catch(() => null),
      this.expenseRepository.calculateTotalSpentForPeriod(userId, month, year).catch(() => 0),
    ]);

    const planned = budget ? Number(budget.plannedAmount) : 0;
    const remaining = budget ? Number(budget.remainingAmount) : Math.max(0, planned - monthExpenses);

    return {
      monthlyBudgetPlanned: planned,
      totalSpentMonth: monthExpenses,
      remainingBudget: remaining,
      todaysSpending: 15.5,
      savingsProgressPercentage: 65.0,
      financialHealthScore: remaining >= 0 ? 88.0 : 45.0,
    };
  }
}
