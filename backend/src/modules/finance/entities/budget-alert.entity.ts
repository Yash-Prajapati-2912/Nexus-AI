import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { AlertType } from '../constants/analytics-enums.constants';

/**
 * Budget Alert Entity.
 * Triggered financial alerts (50%, 75%, 90%, Exceeded, Savings Goal Near Completion / Missed).
 */
@Entity('finance_budget_alerts')
@Index('idx_finance_alerts_user_read', ['userId', 'isRead'])
export class BudgetAlert extends BaseEntity {
  @Index('idx_finance_alerts_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'budget_id', nullable: true })
  budgetId: string | null;

  @Column({ type: 'uuid', name: 'savings_goal_id', nullable: true })
  savingsGoalId: string | null;

  @Column({
    type: 'enum',
    enum: AlertType,
    name: 'alert_type',
  })
  alertType: AlertType;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'threshold_percentage',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  thresholdPercentage: number;

  @Column({ type: 'varchar', length: 500 })
  message: string;

  @Column({ type: 'boolean', name: 'is_read', default: false })
  isRead: boolean;

  @Column({ type: 'timestamp with time zone', name: 'triggered_at', default: () => 'CURRENT_TIMESTAMP' })
  triggeredAt: Date;
}
