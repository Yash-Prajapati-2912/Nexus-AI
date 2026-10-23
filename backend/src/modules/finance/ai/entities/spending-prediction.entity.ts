import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Spending Prediction Entity.
 * Stores AI month-end balance prediction, expected total spending, and savings target achievement probability.
 */
@Entity('finance_spending_predictions')
@Index('idx_finance_predictions_user_period', ['userId', 'month', 'year'])
export class SpendingPrediction extends BaseEntity {
  @Index('idx_finance_predictions_user_id')
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
    name: 'predicted_month_end_balance',
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  predictedMonthEndBalance: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'expected_total_spending',
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  expectedTotalSpending: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'savings_achievement_probability',
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  savingsAchievementProbability: number;

  @Column({ type: 'timestamp with time zone', name: 'budget_exhaustion_date', nullable: true })
  budgetExhaustionDate: Date | null;

  @Column({ type: 'text', nullable: true })
  reasoning: string | null;
}
