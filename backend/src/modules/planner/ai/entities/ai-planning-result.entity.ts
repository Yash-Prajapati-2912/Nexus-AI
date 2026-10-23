import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { AIPlanningActionType } from '../constants/ai-planner.constants';

@Entity('ai_planning_results')
export class AIPlanningResult extends BaseEntity {
  @Index('idx_ai_planning_results_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Index('idx_ai_planning_results_request_id')
  @Column({ type: 'uuid', name: 'request_id', nullable: true })
  requestId: string | null;

  @Column({ type: 'enum', enum: AIPlanningActionType, name: 'action_type' })
  actionType: AIPlanningActionType;

  @Column({ type: 'text' })
  summary: string;

  @Column({ type: 'jsonb', nullable: true })
  reasoning: string[] | null;

  @Column({ type: 'jsonb', nullable: true })
  recommendations: Record<string, any>[] | null;

  @Column({ type: 'jsonb', name: 'action_items', nullable: true })
  actionItems: Record<string, any>[] | null;

  @Column({ type: 'jsonb', nullable: true })
  warnings: string[] | null;

  @Column({ type: 'numeric', precision: 3, scale: 2, name: 'confidence_score', default: 0.9 })
  confidenceScore: number;

  @Column({ type: 'varchar', length: 50, default: 'GEMINI' })
  providerName: string;
}
