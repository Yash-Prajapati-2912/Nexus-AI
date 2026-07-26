import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { AIPlanningActionType } from '../constants/ai-planner.constants';

@Entity('ai_usage_logs')
export class AIUsageLog extends BaseEntity {
  @Index('idx_ai_usage_logs_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'enum', enum: AIPlanningActionType, name: 'action_type' })
  actionType: AIPlanningActionType;

  @Column({ type: 'varchar', length: 50, default: 'GEMINI' })
  providerName: string;

  @Column({ type: 'integer', name: 'prompt_tokens', default: 0 })
  promptTokens: number;

  @Column({ type: 'integer', name: 'completion_tokens', default: 0 })
  completionTokens: number;

  @Column({ type: 'integer', name: 'latency_ms', default: 0 })
  latencyMs: number;
}
