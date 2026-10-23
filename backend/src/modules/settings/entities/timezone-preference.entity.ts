import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Timezone Preference Entity.
 * Timezone offset name, automatic DST adjustments, and location bounds.
 */
@Entity('timezone_preferences')
@Index('idx_tz_prefs_user', ['userId'])
export class TimezonePreference extends BaseEntity {
  @Index('idx_tz_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 100, name: 'timezone_name', default: 'UTC' })
  timezoneName: string;

  @Column({ type: 'boolean', name: 'auto_dst', default: true })
  autoDst: boolean;
}
