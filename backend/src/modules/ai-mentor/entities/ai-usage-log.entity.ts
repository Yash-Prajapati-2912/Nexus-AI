import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * AI Usage Log Entity.
 * Telemetry log tracking token usage, latency, provider name, and user audit logs.
 */
@Entity('ai_mentor_usage_logs')
@Index('idx_mentor_usage_user', ['userId', 'providerName', 'createdAt'])
export class AIUsageLog extends BaseEntity {
  @Index('idx_mentor_usage_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 50, name: 'provider_name', default: 'GEMINI' })
  providerName: string;

  @Column({ type: 'varchar', length: 100, name: 'operation_type' })
  operationType: string;

  @Column({ type: 'integer', name: 'prompt_token_count', default: 0 })
  promptTokenCount: number;

  @Column({ type: 'integer', name: 'candidates_token_count', default: 0 })
  candidatesTokenCount: number;

  @Column({ type: 'integer', name: 'latency_ms', default: 0 })
  latencyMs: number;

  @Column({ type: 'boolean', name: 'is_fallback', default: false })
  isFallback: boolean;
}
