import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { DifficultyLevel } from '../constants/intelligence-enums.constants';

/**
 * Action Plan Entity.
 * Detailed step-by-step action plans with estimated time, difficulty level, priority, and expected outcome.
 */
@Entity('ai_mentor_action_plans')
@Index('idx_mentor_action_plans_user', ['userId', 'priority'])
export class ActionPlan extends BaseEntity {
  @Index('idx_mentor_action_plans_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  summary: string;

  @Column({ type: 'text' })
  reasoning: string;

  @Column({ type: 'simple-array', nullable: true })
  benefits: string[] | null;

  @Column({ type: 'simple-array', name: 'potential_risks', nullable: true })
  potentialRisks: string[] | null;

  @Column({ type: 'jsonb', name: 'action_steps', default: [] })
  actionSteps: Record<string, any>[];

  @Column({ type: 'integer', name: 'estimated_time_minutes', default: 60 })
  estimatedTimeMinutes: number;

  @Column({
    type: 'enum',
    enum: DifficultyLevel,
    default: DifficultyLevel.MEDIUM,
    name: 'difficulty_level',
  })
  difficultyLevel: DifficultyLevel;

  @Column({ type: 'varchar', length: 30, default: 'MEDIUM' })
  priority: string;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'confidence_score',
    default: 0.9,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  confidenceScore: number;

  @Column({ type: 'text', name: 'expected_outcome' })
  expectedOutcome: string;
}
