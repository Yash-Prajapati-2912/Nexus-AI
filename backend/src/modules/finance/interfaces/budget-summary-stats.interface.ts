import { ICategoryBreakdown } from './category-breakdown.interface';

/**
 * Calculated statistics snapshot for monthly summary.
 */
export interface IBudgetSummaryStats {
  month: number;
  year: number;
  totalIncome: number;
  totalExpenses: number;
  plannedBudget: number;
  remainingBudget: number;
  savings: number;
  averageDailySpending: number;
  budgetUtilisationPercentage: number;
  topCategories: ICategoryBreakdown[];
}
