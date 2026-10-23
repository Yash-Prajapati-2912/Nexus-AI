import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

@Entity('productivity_insights')
export class ProductivityInsight extends BaseEntity {
  @Index('idx_productivity_insights_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'focus_score', default: 85.0 })
  focusScore: number;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'consistency_score', default: 90.0 })
  consistencyScore: number;

  @Column({ type: 'text', name: 'most_productive_hours', nullable: true })
  mostProductiveHours: string | null;

  @Column({ type: 'jsonb', nullable: true })
  insights: string[] | null;
}
