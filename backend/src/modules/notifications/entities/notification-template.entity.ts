import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { NotificationCategory, NotificationChannel } from '../constants/notification-enums.constants';

/**
 * Notification Template Entity.
 * Reusable notification titles, body templates, and variable placeholders.
 */
@Entity('notification_templates')
@Index('idx_notification_templates_code', ['code', 'channel'])
export class NotificationTemplate extends BaseEntity {
  @Column({ type: 'varchar', length: 100, unique: true })
  code: string;

  @Column({
    type: 'enum',
    enum: NotificationCategory,
    name: 'default_category',
  })
  defaultCategory: NotificationCategory;

  @Column({
    type: 'enum',
    enum: NotificationChannel,
  })
  channel: NotificationChannel;

  @Column({ type: 'varchar', length: 255, name: 'title_template' })
  titleTemplate: string;

  @Column({ type: 'text', name: 'body_template' })
  bodyTemplate: string;

  @Column({ type: 'simple-array', nullable: true })
  variables: string[] | null;
}
