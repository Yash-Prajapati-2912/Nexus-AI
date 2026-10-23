import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Category Analytics Entity.
 * Aggregated category metrics per user and calendar month/year.
 */
@Entity('finance_category_analytics')
@Index('idx_finance_cat_analytics_user_period', ['userId', 'categoryId', 'month', 'year'], { unique: true })
export class CategoryAnalytics extends BaseEntity {
  @Index('idx_finance_cat_analytics_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'category_id' })
  categoryId: string;

  @Column({ type: 'smallint' })
  month: number;

  @Column({ type: 'integer' })
  year: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_spent',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalSpent: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'percentage_of_total',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  percentageOfTotal: number;

  @Column({ type: 'integer', name: 'transaction_count', default: 0 })
  transactionCount: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'average_per_transaction',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  averagePerTransaction: number;

  @Column({
    type: 'numeric',
    precision: 7,
    scale: 2,
    name: 'monthly_trend_percentage',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  monthlyTrendPercentage: number;
}
