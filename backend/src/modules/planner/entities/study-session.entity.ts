import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { StudyPlan } from './study-plan.entity';
import { StudySessionStatus } from '../constants/study-plan-enums';

/**
 * StudySession Entity.
 * Individual timed study execution log tied to a StudyPlan.
 */
@Entity('study_sessions')
export class StudySession extends BaseEntity {
  @Index('idx_study_sessions_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Index('idx_study_sessions_study_plan_id')
  @Column({ type: 'uuid', name: 'study_plan_id' })
  studyPlanId: string;

  @ManyToOne(() => StudyPlan, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'study_plan_id' })
  studyPlan: StudyPlan;

  @Column({ type: 'timestamp with time zone', name: 'start_time' })
  startTime: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_time', nullable: true })
  endTime: Date | null;

  @Column({ type: 'integer', name: 'duration_minutes', default: 0 })
  durationMinutes: number;

  @Column({ type: 'integer', name: 'break_duration_minutes', default: 0 })
  breakDurationMinutes: number;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({
    type: 'enum',
    enum: StudySessionStatus,
    default: StudySessionStatus.IN_PROGRESS,
  })
  completionStatus: StudySessionStatus;
}
