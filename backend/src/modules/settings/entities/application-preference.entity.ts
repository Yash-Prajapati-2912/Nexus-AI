import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Application Preference Entity.
 * App-level behavior settings (default view, auto save, sound effects).
 */
@Entity('application_preferences')
@Index('idx_app_prefs_user', ['userId'])
export class ApplicationPreference extends BaseEntity {
  @Index('idx_app_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 50, name: 'default_view', default: 'GRID' })
  defaultView: string;

  @Column({ type: 'boolean', name: 'auto_save', default: true })
  autoSave: boolean;

  @Column({ type: 'boolean', name: 'sound_effects', default: true })
  soundEffects: boolean;
}
