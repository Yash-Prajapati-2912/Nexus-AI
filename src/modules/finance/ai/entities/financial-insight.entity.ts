import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { InsightPriority, InsightType } from '../constants/finance-ai-enums.constants';

/**
 * Financial Insight Entity.
 * Individual AI financial insight item.
 */
@Entity('finance_ai_insights')
@Index('idx_finance_ai_insights_user', ['userId', 'priority'])
export class FinancialInsight extends BaseEntity {
  @Index('idx_finance_ai_insights_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: InsightType,
    name: 'insight_type',
  })
  insightType: InsightType;

  @Column({
    type: 'enum',
    enum: InsightPriority,
    default: InsightPriority.MEDIUM,
  })
  priority: InsightPriority;

  @Column({ type: 'varchar', length: 255 })
  summary: string;

  @Column({ type: 'text' })
  detail: string;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'confidence_score',
    default: 0.9,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  confidenceScore: number;
}
