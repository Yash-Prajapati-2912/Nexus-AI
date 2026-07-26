import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { TimeLogEntryType } from '../constants/study-plan-enums';

/**
 * TaskTimeLog Entity.
 * Time tracking entry logged against a Task (manual or automatic timer).
 */
@Entity('task_time_logs')
export class TaskTimeLog extends BaseEntity {
  @Index('idx_task_time_logs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Index('idx_task_time_logs_task_id')
  @Column({ type: 'uuid', name: 'task_id' })
  taskId: string;

  @Column({ type: 'timestamp with time zone', name: 'start_time' })
  startTime: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_time' })
  endTime: Date;

  @Column({ type: 'integer', name: 'duration_minutes' })
  durationMinutes: number;

  @Column({
    type: 'enum',
    enum: TimeLogEntryType,
    default: TimeLogEntryType.MANUAL,
  })
  entryType: TimeLogEntryType;

  @Column({ type: 'text', nullable: true })
  notes: string | null;
}
