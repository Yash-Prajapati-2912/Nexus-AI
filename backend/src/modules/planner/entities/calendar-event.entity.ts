import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * CalendarEvent Entity.
 * Time block on student calendar linked to tasks or assignments.
 */
@Entity('calendar_events')
export class CalendarEvent extends BaseEntity {
  @Index('idx_calendar_events_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Index('idx_calendar_events_start_time')
  @Column({ type: 'timestamp with time zone', name: 'start_time' })
  startTime: Date;

  @Index('idx_calendar_events_end_time')
  @Column({ type: 'timestamp with time zone', name: 'end_time' })
  endTime: Date;

  @Column({ type: 'boolean', name: 'is_all_day', default: false })
  isAllDay: boolean;

  @Column({ type: 'varchar', length: 255, nullable: true })
  location: string | null;

  @Column({ type: 'varchar', length: 30, default: '#3B82F6' })
  colour: string;

  @Index('idx_calendar_events_linked_task_id')
  @Column({ type: 'uuid', name: 'linked_task_id', nullable: true })
  linkedTaskId: string | null;

  @Index('idx_calendar_events_linked_assignment_id')
  @Column({ type: 'uuid', name: 'linked_assignment_id', nullable: true })
  linkedAssignmentId: string | null;

  @Column({ type: 'varchar', length: 50, default: 'UTC' })
  timezone: string;
}
