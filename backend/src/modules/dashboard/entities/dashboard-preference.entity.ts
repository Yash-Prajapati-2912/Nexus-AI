import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Dashboard Preference Entity.
 * General layout settings, theme mode, and default views.
 */
@Entity('dashboard_preferences')
@Index('idx_dashboard_prefs_user', ['userId'])
export class DashboardPreference extends BaseEntity {
  @Index('idx_dashboard_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 50, name: 'default_view', default: 'GRID' })
  defaultView: string;

  @Column({ type: 'boolean', name: 'auto_refresh', default: true })
  autoRefresh: boolean;

  @Column({ type: 'integer', name: 'refresh_interval_seconds', default: 300 })
  refreshIntervalSeconds: number;
}
