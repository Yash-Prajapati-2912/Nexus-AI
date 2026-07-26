import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { NotificationCategory } from '../constants/notification-enums.constants';

/**
 * Notification Entity.
 * Stores in-app user notification items with read state, deep links, and metadata.
 */
@Entity('notifications')
@Index('idx_notifications_user_read', ['userId', 'isRead', 'createdAt'])
export class Notification extends BaseEntity {
  @Index('idx_notifications_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: NotificationCategory,
    default: NotificationCategory.SYSTEM_NOTIFICATION,
  })
  category: NotificationCategory;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  body: string;

  @Column({ type: 'boolean', name: 'is_read', default: false })
  isRead: boolean;

  @Column({ type: 'timestamp with time zone', name: 'read_at', nullable: true })
  readAt: Date | null;

  @Column({ type: 'varchar', length: 500, name: 'deep_link', nullable: true })
  deepLink: string | null;

  @Column({ type: 'jsonb', name: 'action_buttons', nullable: true })
  actionButtons: Record<string, any>[] | null;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any> | null;
}
