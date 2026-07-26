import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Dashboard Snapshot Entity.
 * Stores pre-aggregated JSON dashboard snapshots for ultra-fast response times.
 */
@Entity('dashboard_snapshots')
@Index('idx_dashboard_snapshots_user', ['userId', 'createdAt'])
export class DashboardSnapshot extends BaseEntity {
  @Index('idx_dashboard_snapshots_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'jsonb', name: 'snapshot_data' })
  snapshotData: Record<string, any>;

  @Column({ type: 'varchar', length: 50, name: 'snapshot_version', default: '1.0' })
  snapshotVersion: string;
}
