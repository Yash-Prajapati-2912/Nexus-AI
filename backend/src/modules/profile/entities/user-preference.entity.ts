import { Entity, Column, OneToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { ThemePreference } from '../constants/theme.enum';
import {
  INotificationPreferences,
  IStudyPreferences,
  IReminderPreferences,
  IAiPreferences,
  IPrivacySettings,
} from '../interfaces/user-preference.interface';

/**
 * UserPreference Entity.
 * Stores user system configurations, UI themes, notification rules, AI defaults, and privacy settings in JSONB columns.
 */
@Entity('user_preferences')
export class UserPreference extends BaseEntity {
  @Index('idx_user_preferences_profile_id', { unique: true })
  @Column({ type: 'uuid', name: 'profile_id', unique: true })
  profileId: string;

  @OneToOne(() => UserProfile, (profile) => profile.preferences, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({
    type: 'enum',
    enum: ThemePreference,
    default: ThemePreference.SYSTEM,
  })
  theme: ThemePreference;

  @Column({ type: 'varchar', length: 10, default: 'en' })
  language: string;

  @Column({ type: 'jsonb', name: 'notification_preferences' })
  notificationPreferences: INotificationPreferences;

  @Column({ type: 'jsonb', name: 'study_preferences' })
  studyPreferences: IStudyPreferences;

  @Column({ type: 'jsonb', name: 'reminder_preferences' })
  reminderPreferences: IReminderPreferences;

  @Column({ type: 'jsonb', name: 'ai_preferences' })
  aiPreferences: IAiPreferences;

  @Column({ type: 'jsonb', name: 'privacy_settings' })
  privacySettings: IPrivacySettings;
}
