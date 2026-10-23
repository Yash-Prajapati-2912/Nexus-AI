import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Dashboard Analytics Entity.
 * Aggregated productivity, focus score, completion rates, study time, and wellness metrics.
 */
@Entity('dashboard_analytics')
@Index('idx_dashboard_analytics_user', ['userId', 'createdAt'])
export class DashboardAnalytics extends BaseEntity {
  @Index('idx_dashboard_analytics_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'focus_score',
    default: 80,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  focusScore: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'productivity_score',
    default: 85,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  productivityScore: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'task_completion_rate',
    default: 80,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  taskCompletionRate: number;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'consistency_score',
    default: 82,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  consistencyScore: number;

  @Column({
    type: 'numeric',
    precision: 8,
    scale: 2,
    name: 'total_study_hours',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalStudyHours: number;

  @Column({
    type: 'numeric',
    precision: 8,
    scale: 2,
    name: 'average_daily_study_hours',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  averageDailyStudyHours: number;
}
