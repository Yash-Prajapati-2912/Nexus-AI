import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { ReadinessLevel } from '../constants/intelligence-enums.constants';

/**
 * Career Roadmap Entity.
 * Skill gap detection, internship/placement readiness score, learning path, and timeline.
 */
@Entity('ai_mentor_career_roadmaps')
@Index('idx_mentor_career_user', ['userId', 'createdAt'])
export class CareerRoadmap extends BaseEntity {
  @Index('idx_mentor_career_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255, name: 'target_role' })
  targetRole: string;

  @Column({ type: 'simple-array', name: 'skill_gaps', nullable: true })
  skillGaps: string[] | null;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'readiness_score',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  readinessScore: number;

  @Column({
    type: 'enum',
    enum: ReadinessLevel,
    default: ReadinessLevel.BEGINNER,
    name: 'readiness_level',
  })
  readinessLevel: ReadinessLevel;

  @Column({ type: 'simple-array', name: 'resume_suggestions', nullable: true })
  resumeSuggestions: string[] | null;

  @Column({ type: 'simple-array', name: 'portfolio_recommendations', nullable: true })
  portfolioRecommendations: string[] | null;

  @Column({ type: 'simple-array', name: 'certification_suggestions', nullable: true })
  certificationSuggestions: string[] | null;

  @Column({ type: 'jsonb', name: 'milestones', default: [] })
  milestones: Record<string, any>[];
}
