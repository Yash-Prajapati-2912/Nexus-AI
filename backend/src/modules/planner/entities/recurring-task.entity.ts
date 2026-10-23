import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { RecurrencePattern } from '../constants/recurrence-enums';

/**
 * RecurringTask Entity.
 * Recurrence schedule rule defining automated task generation.
 */
@Entity('recurring_tasks')
export class RecurringTask extends BaseEntity {
  @Index('idx_recurring_tasks_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Index('idx_recurring_tasks_task_id')
  @Column({ type: 'uuid', name: 'task_id', nullable: true })
  taskId: string | null;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({
    type: 'enum',
    enum: RecurrencePattern,
    default: RecurrencePattern.WEEKLY,
  })
  recurrencePattern: RecurrencePattern;

  @Column({ type: 'integer', name: 'interval_days', default: 1 })
  intervalDays: number;

  @Column({ type: 'smallint', name: 'day_of_week', nullable: true })
  dayOfWeek: number | null; // 0-6 (Sunday-Saturday)

  @Column({ type: 'smallint', name: 'day_of_month', nullable: true })
  dayOfMonth: number | null; // 1-31

  @Column({ type: 'timestamp with time zone', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_date', nullable: true })
  endDate: Date | null;

  @Column({ type: 'integer', name: 'max_occurrences', nullable: true })
  maxOccurrences: number | null;

  @Column({ type: 'integer', name: 'current_occurrences', default: 0 })
  currentOccurrences: number;

  @Column({ type: 'boolean', name: 'is_paused', default: false })
  isPaused: boolean;

  @Column({ type: 'jsonb', name: 'skip_dates', nullable: true })
  skipDates: string[] | null; // ISO date strings to skip

  @Index('idx_recurring_tasks_next_occurrence_at')
  @Column({ type: 'timestamp with time zone', name: 'next_occurrence_at', nullable: true })
  nextOccurrenceAt: Date | null;
}
