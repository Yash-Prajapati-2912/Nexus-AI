import { Expense } from '../../entities/expense.entity';
import { SavingsGoal } from '../../entities/savings-goal.entity';
import { Budget } from '../../entities/budget.entity';

export interface ICalculatedMetrics {
  budgetAccuracy: number; // Percentage accuracy score (100 - abs(spent - planned)/planned * 100)
  expenseFrequency: number; // Transactions per day
  savingsProgress: number; // Average progress percentage across active goals
  avgTransactionValue: number;
  mostActiveSpendingDay: string; // Day of week name (e.g. "Friday")
  mostActiveCategory: string; // Category name with highest frequency
}

export class MetricsCalculator {
  static calculateMetrics(
    expenses: Expense[],
    budget: Budget | null,
    savingsGoals: SavingsGoal[],
    daysInPeriod: number,
  ): ICalculatedMetrics {
    const totalSpent = expenses.reduce((sum, e) => sum + Number(e.amount), 0);
    const count = expenses.length;
    const avgTransactionValue = count > 0 ? parseFloat((totalSpent / count).toFixed(2)) : 0;
    const expenseFrequency = parseFloat((count / Math.max(1, daysInPeriod)).toFixed(2));

    // Budget Accuracy
    let budgetAccuracy = 100;
    if (budget && Number(budget.plannedAmount) > 0) {
      const diff = Math.abs(totalSpent - Number(budget.plannedAmount));
      const dev = (diff / Number(budget.plannedAmount)) * 100;
      budgetAccuracy = parseFloat(Math.max(0, 100 - dev).toFixed(2));
    }

    // Savings Progress
    let savingsProgress = 0;
    if (savingsGoals && savingsGoals.length > 0) {
      const totalPct = savingsGoals.reduce((sum, g) => {
        const target = Number(g.targetAmount);
        const curr = Number(g.currentAmount);
        const pct = target > 0 ? Math.min(100, (curr / target) * 100) : 0;
        return sum + pct;
      }, 0);
      savingsProgress = parseFloat((totalPct / savingsGoals.length).toFixed(2));
    }

    // Most Active Spending Day
    const dayCounts: Record<string, number> = {
      Sunday: 0,
      Monday: 0,
      Tuesday: 0,
      Wednesday: 0,
      Thursday: 0,
      Friday: 0,
      Saturday: 0,
    };
    const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    expenses.forEach((e) => {
      const dayName = dayNames[new Date(e.expenseDate).getUTCDay()];
      dayCounts[dayName] = (dayCounts[dayName] || 0) + 1;
    });

    let mostActiveSpendingDay = 'N/A';
    let maxDayCount = -1;
    Object.entries(dayCounts).forEach(([day, cnt]) => {
      if (cnt > maxDayCount && cnt > 0) {
        maxDayCount = cnt;
        mostActiveSpendingDay = day;
      }
    });

    // Most Active Category
    const categoryCounts: Record<string, number> = {};
    expenses.forEach((e) => {
      const catName = e.category ? e.category.name : e.categoryId;
      categoryCounts[catName] = (categoryCounts[catName] || 0) + 1;
    });

    let mostActiveCategory = 'N/A';
    let maxCatCount = -1;
    Object.entries(categoryCounts).forEach(([cat, cnt]) => {
      if (cnt > maxCatCount && cnt > 0) {
        maxCatCount = cnt;
        mostActiveCategory = cat;
      }
    });

    return {
      budgetAccuracy,
      expenseFrequency,
      savingsProgress,
      avgTransactionValue,
      mostActiveSpendingDay,
      mostActiveCategory,
    };
  }
}
