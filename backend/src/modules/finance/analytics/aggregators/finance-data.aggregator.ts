import { Injectable } from '@nestjs/common';
import { ExpenseRepository } from '../../repositories/expense.repository';
import { IncomeRepository } from '../../repositories/income.repository';
import { BudgetRepository } from '../../repositories/budget.repository';
import { SavingsGoalRepository } from '../../repositories/savings-goal.repository';
import { ExpenseCategoryRepository } from '../../repositories/expense-category.repository';
import { Expense } from '../../entities/expense.entity';
import { Income } from '../../entities/income.entity';
import { Budget } from '../../entities/budget.entity';
import { SavingsGoal } from '../../entities/savings-goal.entity';
import { ExpenseCategory } from '../../entities/expense-category.entity';
import { ICategoryBreakdown } from '../../interfaces/category-breakdown.interface';

@Injectable()
export class FinanceDataAggregator {
  constructor(
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly savingsGoalRepository: SavingsGoalRepository,
    private readonly categoryRepository: ExpenseCategoryRepository,
  ) {}

  async aggregatePeriodData(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<{
    expenses: Expense[];
    incomes: Income[];
    budget: Budget | null;
    savingsGoals: SavingsGoal[];
    categories: ExpenseCategory[];
    categoryBreakdown: ICategoryBreakdown[];
  }> {
    const month = startDate.getMonth() + 1;
    const year = startDate.getFullYear();

    const [expenses, incomes, budget, savingsGoals, categories, categoryBreakdown] = await Promise.all([
      this.expenseRepository.findMany({
        where: {
          userId,
        },
        relations: ['category'],
        order: { expenseDate: 'DESC' },
      }),
      this.incomeRepository.findMany({
        where: {
          userId,
        },
        order: { receivedDate: 'DESC' },
      }),
      this.budgetRepository.findByUserAndPeriod(userId, month, year),
      this.savingsGoalRepository.findUserSavingsGoals(userId),
      this.categoryRepository.findAvailableForUser(userId),
      this.expenseRepository.getCategoryBreakdownForPeriod(userId, month, year),
    ]);

    // Filter range in memory using exact epoch time bounds
    const startMs = startDate.getTime();
    const endMs = endDate.getTime();

    const filteredExpenses = expenses.filter((e) => {
      const t = new Date(e.expenseDate).getTime();
      return t >= startMs && t <= endMs;
    });

    const filteredIncomes = incomes.filter((i) => {
      const t = new Date(i.receivedDate).getTime();
      return t >= startMs && t <= endMs;
    });

    return {
      expenses: filteredExpenses,
      incomes: filteredIncomes,
      budget,
      savingsGoals,
      categories,
      categoryBreakdown,
    };
  }
}
