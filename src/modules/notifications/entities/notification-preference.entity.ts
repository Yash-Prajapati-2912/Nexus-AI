import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { ReminderFrequency } from '../constants/notification-enums.constants';

/**
 * Notification Preference Entity.
 * Stores user notification channel toggles, quiet hours, and frequency choices.
 */
@Entity('notification_preferences')
@Index('idx_notification_prefs_user', ['userId'])
export class NotificationPreference extends BaseEntity {
  @Index('idx_notification_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'boolean', name: 'push_enabled', default: true })
  pushEnabled: boolean;

  @Column({ type: 'boolean', name: 'email_enabled', default: true })
  emailEnabled: boolean;

  @Column({ type: 'boolean', name: 'in_app_enabled', default: true })
  inAppEnabled: boolean;

  @Column({ type: 'boolean', name: 'sms_enabled', default: false })
  smsEnabled: boolean;

  @Column({ type: 'varchar', length: 5, name: 'quiet_hours_start', nullable: true, default: '22:00' })
  quietHoursStart: string | null;

  @Column({ type: 'varchar', length: 5, name: 'quiet_hours_end', nullable: true, default: '07:00' })
  quietHoursEnd: string | null;

  @Column({
    type: 'enum',
    enum: ReminderFrequency,
    name: 'reminder_frequency',
    default: ReminderFrequency.IMMEDIATE,
  })
  reminderFrequency: ReminderFrequency;

  @Column({ type: 'jsonb', name: 'category_toggles', nullable: true })
  categoryToggles: Record<string, boolean> | null;
}
