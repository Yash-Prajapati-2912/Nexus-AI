import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * System Setting Entity.
 * Admin system-wide configuration parameters (maintenance mode, rate limits, global alerts).
 */
@Entity('system_settings')
@Index('idx_system_settings_key', ['key'])
export class SystemSetting extends BaseEntity {
  @Column({ type: 'varchar', length: 100, unique: true })
  key: string;

  @Column({ type: 'text' })
  value: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  description: string | null;

  @Column({ type: 'boolean', name: 'is_public', default: false })
  isPublic: boolean;
}
