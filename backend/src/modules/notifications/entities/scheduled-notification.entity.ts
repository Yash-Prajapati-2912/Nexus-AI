import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { NotificationChannel } from '../constants/notification-enums.constants';

/**
 * Scheduled Notification Entity.
 * Stores scheduled future reminders and daily digest jobs.
 */
@Entity('scheduled_notifications')
@Index('idx_scheduled_notifs_user', ['userId', 'scheduledFor', 'isProcessed'])
export class ScheduledNotification extends BaseEntity {
  @Index('idx_scheduled_notifs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: NotificationChannel,
    default: NotificationChannel.IN_APP,
  })
  channel: NotificationChannel;

  @Column({ type: 'timestamp with time zone', name: 'scheduled_for' })
  scheduledFor: Date;

  @Column({ type: 'jsonb' })
  payload: Record<string, any>;

  @Column({ type: 'boolean', name: 'is_processed', default: false })
  isProcessed: boolean;
}
