import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Goal Recommendation Entity.
 * Goal decomposition, SMART milestone generation, risk identification, success probability score.
 */
@Entity('ai_mentor_goal_recommendations')
@Index('idx_mentor_goal_user', ['userId', 'createdAt'])
export class GoalRecommendation extends BaseEntity {
  @Index('idx_mentor_goal_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255, name: 'goal_title' })
  goalTitle: string;

  @Column({ type: 'jsonb', name: 'decomposed_milestones', default: [] })
  decomposedMilestones: Record<string, any>[];

  @Column({ type: 'simple-array', name: 'identified_risks', nullable: true })
  identifiedRisks: string[] | null;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'success_probability',
    default: 80,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  successProbability: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'priority_score',
    default: 50,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  priorityScore: number;
}
