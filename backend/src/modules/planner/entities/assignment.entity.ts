import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { TaskPriority } from '../constants/task-priority.enum';
import { AssignmentStatus } from '../constants/assignment-status.enum';

/**
 * Assignment Entity.
 * Academic assignment, project, or coursework item.
 */
@Entity('assignments')
export class Assignment extends BaseEntity {
  @Index('idx_assignments_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'varchar', length: 255 })
  subject: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  course: string | null;

  @Column({ type: 'smallint', nullable: true })
  semester: number | null;

  @Column({
    type: 'enum',
    enum: TaskPriority,
    default: TaskPriority.HIGH,
  })
  priority: TaskPriority;

  @Column({
    type: 'enum',
    enum: AssignmentStatus,
    default: AssignmentStatus.PENDING,
  })
  status: AssignmentStatus;

  @Column({ type: 'timestamp with time zone' })
  deadline: Date;

  @Column({ type: 'varchar', length: 1000, name: 'submission_link', nullable: true })
  submissionLink: string | null;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'estimated_hours', nullable: true })
  estimatedHours: number | null;

  @Column({ type: 'numeric', precision: 6, scale: 2, name: 'obtained_marks', nullable: true })
  obtainedMarks: number | null;

  @Column({ type: 'numeric', precision: 6, scale: 2, name: 'total_marks', nullable: true })
  totalMarks: number | null;

  @Column({ type: 'jsonb', nullable: true })
  attachments: Record<string, any>[] | null;

  @Column({ type: 'boolean', name: 'is_archived', default: false })
  isArchived: boolean;
}
