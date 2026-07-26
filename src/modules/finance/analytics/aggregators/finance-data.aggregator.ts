import { Injectable } from '@nestjs/common';
import { ExpenseRepository } from '../../repositories/expense.repository';
import { IncomeRepository } from '../../repositories/income.repository';
import { BudgetRepository } from '../../repositories/budget.repository';
import { SavingsGoalRepository } from '../../repositories/savings-goal.repository';
import { Expense } from '../../entities/expense.entity';
import { Income } from '../../entities/income.entity';
import { Budget } from '../../entities/budget.entity';
import { SavingsGoal } from '../../entities/savings-goal.entity';

@Injectable()
export class FinanceDataAggregator {
  constructor(
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly savingsGoalRepository: SavingsGoalRepository,
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
  }> {
    const month = startDate.getUTCMonth() + 1;
    const year = startDate.getUTCFullYear();

    const [expenses, incomes, budget, savingsGoals] = await Promise.all([
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
    ]);

    // Filter range in memory for exact date bounds
    const filteredExpenses = expenses.filter(
      (e) => e.expenseDate >= startDate && e.expenseDate <= endDate,
    );
    const filteredIncomes = incomes.filter(
      (i) => i.receivedDate >= startDate && i.receivedDate <= endDate,
    );

    return {
      expenses: filteredExpenses,
      incomes: filteredIncomes,
      budget,
      savingsGoals,
    };
  }
}
