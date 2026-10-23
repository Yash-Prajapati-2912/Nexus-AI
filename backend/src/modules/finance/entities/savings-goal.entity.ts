import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { SavingsPriority, SavingsStatus } from '../constants/finance-enums.constants';

/**
 * Savings Goal Entity.
 * Target monetary objective for a student (e.g. emergency fund, laptop, travel, course).
 */
@Entity('finance_savings_goals')
@Index('idx_finance_savings_user_status', ['userId', 'status'])
export class SavingsGoal extends BaseEntity {
  @Index('idx_finance_savings_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'target_amount',
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  targetAmount: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'current_amount',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  currentAmount: number;

  @Column({ type: 'timestamp with time zone', name: 'target_date' })
  targetDate: Date;

  @Column({
    type: 'enum',
    enum: SavingsPriority,
    default: SavingsPriority.MEDIUM,
  })
  priority: SavingsPriority;

  @Column({
    type: 'enum',
    enum: SavingsStatus,
    default: SavingsStatus.IN_PROGRESS,
  })
  status: SavingsStatus;

  @Column({ type: 'text', nullable: true })
  description: string | null;
}
