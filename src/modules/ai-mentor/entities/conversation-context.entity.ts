import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Conversation Context Entity.
 * Stores structured context snapshots (profile, goals, planner, finance metrics) attached to conversation sessions.
 */
@Entity('ai_mentor_conversation_contexts')
@Index('idx_mentor_context_conv', ['conversationId'])
export class ConversationContext extends BaseEntity {
  @Index('idx_mentor_context_conv_id')
  @Column({ type: 'uuid', name: 'conversation_id' })
  conversationId: string;

  @Column({ type: 'jsonb', name: 'context_snapshot' })
  contextSnapshot: Record<string, any>;

  @Column({ type: 'integer', name: 'version', default: 1 })
  contextVersion: number;
}
