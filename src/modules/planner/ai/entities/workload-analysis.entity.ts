import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

@Entity('workload_analyses')
export class WorkloadAnalysis extends BaseEntity {
  @Index('idx_workload_analyses_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'daily_load_hours', default: 4.5 })
  dailyLoadHours: number;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'weekly_load_hours', default: 28.0 })
  weeklyLoadHours: number;

  @Column({ type: 'jsonb', name: 'overloaded_days', nullable: true })
  overloadedDays: string[] | null;

  @Column({ type: 'text', name: 'recommendations_text', nullable: true })
  recommendationsText: string | null;
}
