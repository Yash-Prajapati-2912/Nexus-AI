import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Savings Recommendation Entity.
 * Goal-based savings plans, expense reduction strategies, and emergency fund advice.
 */
@Entity('finance_savings_recommendations')
@Index('idx_finance_savings_recs_user', ['userId', 'createdAt'])
export class SavingsRecommendation extends BaseEntity {
  @Index('idx_finance_savings_recs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  strategy: string;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'suggested_monthly_contribution',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  suggestedMonthlyContribution: number;

  @Column({ type: 'simple-array', name: 'target_categories_to_cut', nullable: true })
  targetCategoriesToCut: string[] | null;

  @Column({ type: 'text', name: 'emergency_fund_advice', nullable: true })
  emergencyFundAdvice: string | null;
}
