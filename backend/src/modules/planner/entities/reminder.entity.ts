import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import {
  ReminderRepeatType,
  ReminderStatus,
  ReminderDeliveryMethod,
} from '../constants/reminder-enums';

/**
 * Reminder Entity.
 * Scheduled notification reminder associated with a user or task.
 */
@Entity('reminders')
export class Reminder extends BaseEntity {
  @Index('idx_reminders_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Index('idx_reminders_task_id')
  @Column({ type: 'uuid', name: 'task_id', nullable: true })
  taskId: string | null;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Index('idx_reminders_remind_at')
  @Column({ type: 'timestamp with time zone', name: 'remind_at' })
  remindAt: Date;

  @Column({
    type: 'enum',
    enum: ReminderRepeatType,
    default: ReminderRepeatType.NONE,
  })
  repeatType: ReminderRepeatType;

  @Column({
    type: 'enum',
    enum: ReminderStatus,
    default: ReminderStatus.PENDING,
  })
  status: ReminderStatus;

  @Column({ type: 'boolean', name: 'is_sent', default: false })
  isSent: boolean;

  @Column({
    type: 'enum',
    enum: ReminderDeliveryMethod,
    default: ReminderDeliveryMethod.IN_APP,
  })
  deliveryMethod: ReminderDeliveryMethod;
}
