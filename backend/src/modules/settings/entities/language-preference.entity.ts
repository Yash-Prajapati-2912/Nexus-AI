import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Language Preference Entity.
 * System locale, translation choices, and fallback languages.
 */
@Entity('language_preferences')
@Index('idx_lang_prefs_user', ['userId'])
export class LanguagePreference extends BaseEntity {
  @Index('idx_lang_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 10, default: 'en' })
  locale: string;

  @Column({ type: 'varchar', length: 10, name: 'fallback_locale', default: 'en-US' })
  fallbackLocale: string;
}
