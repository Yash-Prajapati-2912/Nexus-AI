import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { NotificationChannel, NotificationStatus } from '../constants/notification-enums.constants';

/**
 * Notification History Entity.
 * Delivery audit trail recording status, delivery channel, attempt count, and error messages.
 */
@Entity('notification_histories')
@Index('idx_notification_history_user', ['userId', 'status'])
export class NotificationHistory extends BaseEntity {
  @Index('idx_notification_history_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: NotificationChannel,
  })
  channel: NotificationChannel;

  @Column({
    type: 'enum',
    enum: NotificationStatus,
    default: NotificationStatus.PENDING,
  })
  status: NotificationStatus;

  @Column({ type: 'integer', name: 'attempt_count', default: 1 })
  attemptCount: number;

  @Column({ type: 'timestamp with time zone', name: 'delivered_at', nullable: true })
  deliveredAt: Date | null;

  @Column({ type: 'text', name: 'failure_reason', nullable: true })
  failureReason: string | null;

  @Column({ type: 'jsonb', nullable: true })
  payload: Record<string, any> | null;
}
