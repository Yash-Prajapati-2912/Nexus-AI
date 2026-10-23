import { Entity, Column, Index, ManyToOne, JoinColumn } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { PaymentMethod } from '../constants/finance-enums.constants';
import { ExpenseCategory } from './expense-category.entity';
import { Budget } from './budget.entity';

/**
 * Expense Entity.
 * Individual financial expenditure incurred by a student.
 */
@Entity('finance_expenses')
@Index('idx_finance_expenses_user_date', ['userId', 'expenseDate'])
@Index('idx_finance_expenses_category', ['categoryId'])
@Index('idx_finance_expenses_budget', ['budgetId'])
export class Expense extends BaseEntity {
  @Index('idx_finance_expenses_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'budget_id', nullable: true })
  budgetId: string | null;

  @ManyToOne(() => Budget, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'budget_id' })
  budget: Budget | null;

  @Column({ type: 'uuid', name: 'category_id' })
  categoryId: string;

  @ManyToOne(() => ExpenseCategory, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'category_id' })
  category: ExpenseCategory;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  amount: number;

  @Column({ type: 'timestamp with time zone', name: 'expense_date' })
  expenseDate: Date;

  @Column({
    type: 'enum',
    enum: PaymentMethod,
    name: 'payment_method',
    default: PaymentMethod.DEBIT_CARD,
  })
  paymentMethod: PaymentMethod;

  @Column({ type: 'varchar', length: 150, nullable: true })
  merchant: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  location: string | null;

  @Column({ type: 'varchar', length: 500, name: 'receipt_url', nullable: true })
  receiptUrl: string | null;

  @Column({ type: 'boolean', name: 'is_recurring', default: false })
  isRecurring: boolean;

  @Column({ type: 'simple-array', nullable: true })
  tags: string[] | null;

  @Column({ type: 'text', nullable: true })
  notes: string | null;
}
