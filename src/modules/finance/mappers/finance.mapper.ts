import { Budget } from '../entities/budget.entity';
import { ExpenseCategory } from '../entities/expense-category.entity';
import { Expense } from '../entities/expense.entity';
import { Income } from '../entities/income.entity';
import { SavingsGoal } from '../entities/savings-goal.entity';
import { MonthlySummary } from '../entities/monthly-summary.entity';

import { BudgetResponseDto } from '../dto/budget-response.dto';
import { ExpenseCategoryResponseDto } from '../dto/expense-category-response.dto';
import { ExpenseResponseDto } from '../dto/expense-response.dto';
import { IncomeResponseDto } from '../dto/income-response.dto';
import { SavingsGoalResponseDto } from '../dto/savings-goal-response.dto';
import { MonthlySummaryResponseDto } from '../dto/monthly-summary-response.dto';

export class FinanceMapper {
  static toBudgetDto(entity: Budget): BudgetResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      month: entity.month,
      year: entity.year,
      plannedAmount: Number(entity.plannedAmount),
      spentAmount: Number(entity.spentAmount),
      remainingAmount: Number(entity.remainingAmount),
      currency: entity.currency,
      status: entity.status,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    };
  }

  static toCategoryDto(entity: ExpenseCategory): ExpenseCategoryResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      isDefault: entity.isDefault,
      colour: entity.colour,
      icon: entity.icon,
      monthlyLimit: entity.monthlyLimit !== null ? Number(entity.monthlyLimit) : null,
      sortOrder: entity.sortOrder,
      isVisible: entity.isVisible,
      createdAt: entity.createdAt,
    };
  }

  static toExpenseDto(entity: Expense): ExpenseResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      budgetId: entity.budgetId,
      categoryId: entity.categoryId,
      category: entity.category ? FinanceMapper.toCategoryDto(entity.category) : undefined,
      title: entity.title,
      description: entity.description,
      amount: Number(entity.amount),
      expenseDate: entity.expenseDate,
      paymentMethod: entity.paymentMethod,
      merchant: entity.merchant,
      location: entity.location,
      receiptUrl: entity.receiptUrl,
      isRecurring: entity.isRecurring,
      tags: entity.tags || [],
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    };
  }

  static toIncomeDto(entity: Income): IncomeResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      source: entity.source,
      amount: Number(entity.amount),
      frequency: entity.frequency,
      receivedDate: entity.receivedDate,
      description: entity.description,
      isRecurring: entity.isRecurring,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    };
  }

  static toSavingsGoalDto(entity: SavingsGoal): SavingsGoalResponseDto {
    const target = Number(entity.targetAmount);
    const current = Number(entity.currentAmount);
    const progressPercentage = target > 0 ? parseFloat(Math.min(100, (current / target) * 100).toFixed(2)) : 0;

    return {
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      targetAmount: target,
      currentAmount: current,
      progressPercentage,
      targetDate: entity.targetDate,
      priority: entity.priority,
      status: entity.status,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    };
  }

  static toMonthlySummaryDto(entity: MonthlySummary): MonthlySummaryResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      month: entity.month,
      year: entity.year,
      totalIncome: Number(entity.totalIncome),
      totalExpenses: Number(entity.totalExpenses),
      remainingBudget: Number(entity.remainingBudget),
      savings: Number(entity.savings),
      averageDailySpending: Number(entity.averageDailySpending),
      topCategories: entity.topCategories || [],
      budgetUtilisationPercentage: Number(entity.budgetUtilisationPercentage),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    };
  }
}
