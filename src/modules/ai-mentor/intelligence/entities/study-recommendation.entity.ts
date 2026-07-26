import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * Study Recommendation Entity.
 * Subject priority analysis, weak subject detection, revision planning, exam prep strategy.
 */
@Entity('ai_mentor_study_recommendations')
@Index('idx_mentor_study_user', ['userId', 'createdAt'])
export class StudyRecommendation extends BaseEntity {
  @Index('idx_mentor_study_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'simple-array', name: 'weak_subjects', nullable: true })
  weakSubjects: string[] | null;

  @Column({ type: 'jsonb', name: 'subject_priorities', default: [] })
  subjectPriorities: Record<string, any>[];

  @Column({ type: 'text', name: 'exam_prep_strategy' })
  examPrepStrategy: string;

  @Column({ type: 'text', name: 'revision_schedule' })
  revisionSchedule: string;

  @Column({ type: 'simple-array', name: 'learning_style_tips', nullable: true })
  learningStyleTips: string[] | null;
}
