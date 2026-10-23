import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

/**
 * AI Finance Usage Log Entity.
 * Audit and token telemetry logging for AI financial provider queries.
 */
@Entity('finance_ai_usage_logs')
@Index('idx_finance_ai_logs_user', ['userId', 'providerName', 'createdAt'])
export class AIFinanceUsageLog extends BaseEntity {
  @Index('idx_finance_ai_logs_user_id')
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
