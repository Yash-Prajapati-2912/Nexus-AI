import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { BudgetStatus } from '../constants/finance-enums.constants';

/**
 * Budget Entity.
 * Represents a student's planned financial allocations per calendar month and year.
 */
@Entity('finance_budgets')
@Index('idx_finance_budgets_user_month_year', ['userId', 'month', 'year'], { unique: true })
export class Budget extends BaseEntity {
  @Index('idx_finance_budgets_user_id')
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
    name: 'planned_amount',
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  plannedAmount: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'remaining_amount',
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  remainingAmount: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'spent_amount',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  spentAmount: number;

  @Column({ type: 'varchar', length: 10, default: 'USD' })
  currency: string;

  @Column({
    type: 'enum',
    enum: BudgetStatus,
    default: BudgetStatus.ACTIVE,
  })
  status: BudgetStatus;

  @Column({ type: 'text', nullable: true })
  notes: string | null;
}
