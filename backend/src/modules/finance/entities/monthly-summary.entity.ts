import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { ICategoryBreakdown } from '../interfaces/category-breakdown.interface';

/**
 * Monthly Summary Entity.
 * Aggregated monthly snapshot of income, expenses, budget utilisation, and category distribution.
 */
@Entity('finance_monthly_summaries')
@Index('idx_finance_summary_user_month_year', ['userId', 'month', 'year'], { unique: true })
export class MonthlySummary extends BaseEntity {
  @Index('idx_finance_summary_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'smallint' })
  month: number;

  @Column({ type: 'integer' })
  year: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_income',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  totalIncome: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_expenses',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  totalExpenses: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'remaining_budget',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  remainingBudget: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  savings: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'average_daily_spending',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  averageDailySpending: number;

  @Column({ type: 'jsonb', name: 'top_categories', default: [] })
  topCategories: ICategoryBreakdown[];

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'budget_utilisation_percentage',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  budgetUtilisationPercentage: number;
}
