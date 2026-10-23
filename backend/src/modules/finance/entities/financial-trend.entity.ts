import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Financial Trend Entity.
 * Periodical trend statistics (income growth, expense growth, savings growth, budget consumption).
 */
@Entity('finance_trends')
@Index('idx_finance_trends_user_period', ['userId', 'periodType', 'periodLabel'], { unique: true })
export class FinancialTrend extends BaseEntity {
  @Index('idx_finance_trends_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 20, name: 'period_type', default: 'MONTHLY' })
  periodType: string;

  @Column({ type: 'varchar', length: 30, name: 'period_label' })
  periodLabel: string; // e.g. '2026-09' or '2026-W37'

  @Column({
    type: 'numeric',
    precision: 7,
    scale: 2,
    name: 'income_growth_percentage',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  incomeGrowthPercentage: number;

  @Column({
    type: 'numeric',
    precision: 7,
    scale: 2,
    name: 'expense_growth_percentage',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  expenseGrowthPercentage: number;

  @Column({
    type: 'numeric',
    precision: 7,
    scale: 2,
    name: 'savings_growth_percentage',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  savingsGrowthPercentage: number;

  @Column({
    type: 'numeric',
    precision: 7,
    scale: 2,
    name: 'budget_consumption_rate',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  budgetConsumptionRate: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'net_cash_flow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  netCashFlow: number;
}
