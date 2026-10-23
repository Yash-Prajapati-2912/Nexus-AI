import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { DomainSource } from '../constants/dashboard-enums.constants';

/**
 * Activity Timeline Entity.
 * Consolidated cross-domain activity event feed (Planner, Finance, Mentor, Profile, Achievements).
 */
@Entity('dashboard_activity_timelines')
@Index('idx_dashboard_timeline_user', ['userId', 'activityDate'])
export class ActivityTimeline extends BaseEntity {
  @Index('idx_dashboard_timeline_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: DomainSource,
    name: 'domain_source',
  })
  domainSource: DomainSource;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'timestamp with time zone', name: 'activity_date', default: () => 'CURRENT_TIMESTAMP' })
  activityDate: Date;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any> | null;
}
