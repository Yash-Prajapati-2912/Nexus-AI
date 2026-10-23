import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { AnalyticsPeriod } from '../constants/analytics-enums.constants';

/**
 * Financial Analytics Entity.
 * Periodical analytics snapshot storing aggregated spending, mean, median, min, max, and savings rates.
 */
@Entity('finance_analytics')
@Index('idx_finance_analytics_user_period', ['userId', 'period', 'startDate', 'endDate'])
export class FinancialAnalytics extends BaseEntity {
  @Index('idx_finance_analytics_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: AnalyticsPeriod,
    default: AnalyticsPeriod.MONTHLY,
  })
  period: AnalyticsPeriod;

  @Column({ type: 'timestamp with time zone', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_date' })
  endDate: Date;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_income',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalIncome: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_expenses',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalExpenses: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'net_balance',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  netBalance: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'savings_rate',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  savingsRate: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'average_daily_spending',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  avgDailySpending: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'median_spending',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  medianSpending: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'highest_expense',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  highestExpense: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'lowest_expense',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  lowestExpense: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'budget_utilisation',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  budgetUtilisation: number;
}
