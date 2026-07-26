import { Budget } from '../../entities/budget.entity';
import { Expense } from '../../entities/expense.entity';
import { Income } from '../../entities/income.entity';
import { SavingsGoal } from '../../entities/savings-goal.entity';
import { ExpenseCategory } from '../../entities/expense-category.entity';

export interface IAIFinancePromptContext {
  userId: string;
  budget: Budget | null;
  incomes: Income[];
  expenses: Expense[];
  savingsGoals: SavingsGoal[];
  categories: ExpenseCategory[];
  totalIncome: number;
  totalExpenses: number;
  remainingBudget: number;
  daysRemainingInMonth: number;
  studentProfile?: {
    careerGoals?: string[];
    studyPreferences?: string[];
  };
}
