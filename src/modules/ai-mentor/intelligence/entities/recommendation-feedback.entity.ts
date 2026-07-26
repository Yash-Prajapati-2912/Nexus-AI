import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { FeedbackRating } from '../constants/intelligence-enums.constants';

/**
 * Recommendation Feedback Entity.
 * User ratings (1-5), helpful/not helpful votes, and adaptive recommendation weighting adjustments.
 */
@Entity('ai_mentor_recommendation_feedbacks')
@Index('idx_mentor_rec_feedback_user', ['userId', 'recommendationId'])
export class RecommendationFeedback extends BaseEntity {
  @Index('idx_mentor_rec_feedback_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'recommendation_id' })
  recommendationId: string;

  @Column({
    type: 'enum',
    enum: FeedbackRating,
    default: FeedbackRating.HELPFUL,
    name: 'rating_score',
  })
  ratingScore: FeedbackRating;

  @Column({ type: 'boolean', name: 'is_helpful', default: true })
  isHelpful: boolean;

  @Column({ type: 'text', nullable: true })
  comments: string | null;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'weight_adjustment',
    default: 1.0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  weightAdjustment: number;
}
