import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Decision Analysis Entity.
 * Trade-off matrix, pros and cons, opportunity cost, risk assessment, confidence score.
 */
@Entity('ai_mentor_decision_analyses')
@Index('idx_mentor_decision_user', ['userId', 'createdAt'])
export class DecisionAnalysis extends BaseEntity {
  @Index('idx_mentor_decision_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255, name: 'decision_title' })
  decisionTitle: string;

  @Column({ type: 'simple-array', nullable: true })
  pros: string[] | null;

  @Column({ type: 'simple-array', nullable: true })
  cons: string[] | null;

  @Column({ type: 'text', name: 'opportunity_cost' })
  opportunityCost: string;

  @Column({ type: 'text', name: 'risk_assessment' })
  riskAssessment: string;

  @Column({ type: 'text', name: 'long_term_impact' })
  longTermImpact: string;

  @Column({ type: 'simple-array', name: 'alternative_suggestions', nullable: true })
  alternativeSuggestions: string[] | null;

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
