import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Mentor Insight Entity.
 * Granular intelligence insights generated across career, study, decision, and wellness modules.
 */
@Entity('ai_mentor_intelligence_insights')
@Index('idx_mentor_intel_insights_user', ['userId', 'domainCategory'])
export class MentorInsight extends BaseEntity {
  @Index('idx_mentor_intel_insights_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 100, name: 'domain_category' })
  domainCategory: string;

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
