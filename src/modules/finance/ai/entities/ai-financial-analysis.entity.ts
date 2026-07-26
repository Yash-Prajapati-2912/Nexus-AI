import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * AI Financial Analysis Entity.
 * Stores comprehensive AI executive summary, strengths, weaknesses, and confidence scores.
 */
@Entity('finance_ai_financial_analyses')
@Index('idx_finance_ai_analysis_user', ['userId', 'createdAt'])
export class AIFinancialAnalysis extends BaseEntity {
  @Index('idx_finance_ai_analysis_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'text' })
  summary: string;

  @Column({ type: 'simple-array', nullable: true })
  strengths: string[] | null;

  @Column({ type: 'simple-array', nullable: true })
  weaknesses: string[] | null;

  @Column({ type: 'jsonb', name: 'recommendations', default: [] })
  recommendations: Record<string, any>[];

  @Column({ type: 'simple-array', nullable: true })
  warnings: string[] | null;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'confidence_score',
    default: 0.9,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  confidenceScore: number;

  @Column({ type: 'varchar', length: 50, name: 'provider_name', default: 'GEMINI' })
  providerName: string;
}
