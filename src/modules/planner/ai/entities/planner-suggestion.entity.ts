import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

@Entity('planner_suggestions')
export class PlannerSuggestion extends BaseEntity {
  @Index('idx_planner_suggestions_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  suggestion: string;

  @Column({ type: 'boolean', name: 'is_applied', default: false })
  isApplied: boolean;
}
