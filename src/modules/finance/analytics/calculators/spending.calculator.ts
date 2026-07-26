import { Expense } from '../../entities/expense.entity';

export interface ISpendingStats {
  totalExpenses: number;
  avgDailySpending: number;
  medianSpending: number;
  highestExpense: number;
  lowestExpense: number;
  transactionCount: number;
}

export class SpendingCalculator {
  static calculateStats(expenses: Expense[], totalDays: number): ISpendingStats {
    if (!expenses || expenses.length === 0) {
      return {
        totalExpenses: 0,
        avgDailySpending: 0,
        medianSpending: 0,
        highestExpense: 0,
        lowestExpense: 0,
        transactionCount: 0,
      };
    }

    const amounts = expenses.map((e) => Number(e.amount)).sort((a, b) => a - b);
    const totalExpenses = parseFloat(amounts.reduce((sum, val) => sum + val, 0).toFixed(2));
    const highestExpense = amounts[amounts.length - 1];
    const lowestExpense = amounts[0];

    const days = Math.max(1, totalDays);
    const avgDailySpending = parseFloat((totalExpenses / days).toFixed(2));

    let medianSpending = 0;
    const mid = Math.floor(amounts.length / 2);
    if (amounts.length % 2 === 0) {
      medianSpending = parseFloat(((amounts[mid - 1] + amounts[mid]) / 2).toFixed(2));
    } else {
      medianSpending = parseFloat(amounts[mid].toFixed(2));
    }

    return {
      totalExpenses,
      avgDailySpending,
      medianSpending,
      highestExpense,
      lowestExpense,
      transactionCount: expenses.length,
    };
  }
}
