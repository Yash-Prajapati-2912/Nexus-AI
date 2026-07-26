import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Mentor Feedback Entity.
 * User rating and commentary feedback on mentor responses.
 */
@Entity('ai_mentor_feedback')
@Index('idx_mentor_feedback_message', ['messageId'])
export class MentorFeedback extends BaseEntity {
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'uuid', name: 'message_id' })
  messageId: string;

  @Column({ type: 'integer', name: 'rating_score', default: 5 })
  ratingScore: number;

  @Column({ type: 'text', nullable: true })
  comments: string | null;
}
