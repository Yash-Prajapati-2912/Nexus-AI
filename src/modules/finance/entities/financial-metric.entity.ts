import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { MetricKey } from '../constants/analytics-enums.constants';

/**
 * Financial Metric Entity.
 * Granular calculated financial metric (e.g. Budget Accuracy, Expense Frequency, Savings Progress).
 */
@Entity('finance_metrics')
@Index('idx_finance_metrics_user_key', ['userId', 'metricKey'])
export class FinancialMetric extends BaseEntity {
  @Index('idx_finance_metrics_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: MetricKey,
    name: 'metric_key',
  })
  metricKey: MetricKey;

  @Column({ type: 'varchar', length: 255, name: 'metric_value' })
  metricValue: string;

  @Column({ type: 'varchar', length: 50, default: 'MONTHLY' })
  period: string;

  @Column({ type: 'timestamp with time zone', name: 'calculated_at', default: () => 'CURRENT_TIMESTAMP' })
  calculatedAt: Date;
}
