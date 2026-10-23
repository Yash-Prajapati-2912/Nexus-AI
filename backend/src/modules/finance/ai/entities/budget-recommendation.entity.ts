import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Budget Recommendation Entity.
 * AI recommendations for category limit adjustments and spending mitigations.
 */
@Entity('finance_budget_recommendations')
@Index('idx_finance_budget_recs_user', ['userId', 'createdAt'])
export class BudgetRecommendation extends BaseEntity {
  @Index('idx_finance_budget_recs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'category_id', nullable: true })
  categoryId: string | null;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'recommended_limit',
    nullable: true,
    transformer: { to: (v: number | null) => v, from: (v: string | null) => (v !== null ? parseFloat(v) : null) },
  })
  recommendedLimit: number | null;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'potential_monthly_savings',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  potentialMonthlySavings: number;

  @Column({ type: 'varchar', length: 30, default: 'MEDIUM' })
  priority: string;
}
