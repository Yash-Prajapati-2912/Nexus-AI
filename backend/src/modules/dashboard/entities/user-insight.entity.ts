import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { InsightPriorityLevel } from '../constants/dashboard-enums.constants';

/**
 * User Insight Entity.
 * Personalized daily, weekly, and monthly summary insights, priority alerts, and improvement tips.
 */
@Entity('dashboard_user_insights')
@Index('idx_dashboard_user_insights_user', ['userId', 'priorityLevel'])
export class UserInsight extends BaseEntity {
  @Index('idx_dashboard_user_insights_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  summary: string;

  @Column({ type: 'text' })
  detail: string;

  @Column({
    type: 'enum',
    enum: InsightPriorityLevel,
    default: InsightPriorityLevel.MEDIUM,
    name: 'priority_level',
  })
  priorityLevel: InsightPriorityLevel;

  @Column({ type: 'varchar', length: 50, name: 'domain_category', default: 'GENERAL' })
  domainCategory: string;

  @Column({ type: 'boolean', name: 'is_read', default: false })
  isRead: boolean;
}
