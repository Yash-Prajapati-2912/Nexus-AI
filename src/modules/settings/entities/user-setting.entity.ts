import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { ThemeMode, StartOfWeek } from '../constants/settings-enums.constants';

/**
 * User Setting Entity.
 * Central user configuration (theme, language, timezone, date/time format, start of week, privacy).
 */
@Entity('user_settings')
@Index('idx_user_settings_user', ['userId'])
export class UserSetting extends BaseEntity {
  @Index('idx_user_settings_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({
    type: 'enum',
    enum: ThemeMode,
    default: ThemeMode.SYSTEM,
  })
  theme: ThemeMode;

  @Column({ type: 'varchar', length: 10, default: 'en-US' })
  language: string;

  @Column({ type: 'varchar', length: 100, default: 'UTC' })
  timezone: string;

  @Column({ type: 'varchar', length: 30, name: 'date_format', default: 'YYYY-MM-DD' })
  dateFormat: string;

  @Column({ type: 'varchar', length: 20, name: 'time_format', default: '24h' })
  timeFormat: string;

  @Column({
    type: 'enum',
    enum: StartOfWeek,
    name: 'start_of_week',
    default: StartOfWeek.MONDAY,
  })
  startOfWeek: StartOfWeek;

  @Column({ type: 'jsonb', name: 'privacy_settings', nullable: true })
  privacySettings: Record<string, any> | null;
}
