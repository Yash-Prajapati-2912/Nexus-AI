import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { TaskPriority } from '../constants/task-priority.enum';
import { StudyPlanStatus } from '../constants/study-plan-enums';

/**
 * StudyPlan Entity.
 * Academic course study plan with target vs completed study hours.
 */
@Entity('study_plans')
export class StudyPlan extends BaseEntity {
  @Index('idx_study_plans_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  subject: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  course: string | null;

  @Column({ type: 'numeric', precision: 6, scale: 2, name: 'target_hours', default: 20.0 })
  targetHours: number;

  @Column({ type: 'numeric', precision: 6, scale: 2, name: 'completed_hours', default: 0.0 })
  completedHours: number;

  @Column({ type: 'timestamp with time zone', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_date' })
  endDate: Date;

  @Column({
    type: 'enum',
    enum: TaskPriority,
    default: TaskPriority.MEDIUM,
  })
  priority: TaskPriority;

  @Column({
    type: 'enum',
    enum: StudyPlanStatus,
    default: StudyPlanStatus.ACTIVE,
  })
  status: StudyPlanStatus;
}
