import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { MentorRecommendationPriority } from '../constants/mentor-enums.constants';

/**
 * Mentor Recommendation Entity.
 * Actionable recommendations produced by AI Mentor.
 */
@Entity('ai_mentor_recommendations')
@Index('idx_mentor_recs_user', ['userId', 'priority'])
export class MentorRecommendation extends BaseEntity {
  @Index('idx_mentor_recs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'enum',
    enum: MentorRecommendationPriority,
    default: MentorRecommendationPriority.MEDIUM,
  })
  priority: MentorRecommendationPriority;

  @Column({ type: 'varchar', length: 50, name: 'domain_category', default: 'GENERAL' })
  domainCategory: string;

  @Column({ type: 'boolean', name: 'is_applied', default: false })
  isApplied: boolean;
}
