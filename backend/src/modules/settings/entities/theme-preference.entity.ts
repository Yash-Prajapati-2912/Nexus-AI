import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Theme Preference Entity.
 * Visual themes, custom primary colors, and font scaling options.
 */
@Entity('theme_preferences')
@Index('idx_theme_prefs_user', ['userId'])
export class ThemePreference extends BaseEntity {
  @Index('idx_theme_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 20, name: 'primary_color', default: '#3B82F6' })
  primaryColor: string;

  @Column({ type: 'varchar', length: 20, name: 'font_size', default: 'MEDIUM' })
  fontSize: string;
}
