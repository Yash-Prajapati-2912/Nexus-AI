import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Expense Category Entity.
 * Classification bucket for expenses. Supports system defaults and custom user categories.
 */
@Entity('finance_expense_categories')
@Index('idx_finance_categories_user_name', ['userId', 'name'])
export class ExpenseCategory extends BaseEntity {
  @Index('idx_finance_categories_user_id')
  @Column({ type: 'uuid', name: 'user_id', nullable: true })
  userId: string | null;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'boolean', name: 'is_default', default: false })
  isDefault: boolean;

  @Column({ type: 'varchar', length: 30, default: '#6366F1' })
  colour: string;

  @Column({ type: 'varchar', length: 50, default: 'tag' })
  icon: string;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'monthly_limit',
    nullable: true,
    transformer: {
      to: (value: number | null) => value,
      from: (value: string | null) => (value !== null ? parseFloat(value) : null),
    },
  })
  monthlyLimit: number | null;

  @Column({ type: 'smallint', name: 'sort_order', default: 0 })
  sortOrder: number;

  @Column({ type: 'boolean', name: 'is_visible', default: true })
  isVisible: boolean;
}
