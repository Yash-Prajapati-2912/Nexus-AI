import { Entity, Column, Index, ManyToOne, JoinColumn } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { MessageRole } from '../constants/mentor-enums.constants';
import { Conversation } from './conversation.entity';

/**
 * Conversation Message Entity.
 * Individual turns (User prompts, AI structured responses, telemetry).
 */
@Entity('ai_mentor_conversation_messages')
@Index('idx_mentor_messages_conv', ['conversationId', 'createdAt'])
export class ConversationMessage extends BaseEntity {
  @Index('idx_mentor_messages_conv_id')
  @Column({ type: 'uuid', name: 'conversation_id' })
  conversationId: string;

  @ManyToOne(() => Conversation, (conv) => conv.messages, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'conversation_id' })
  conversation: Conversation;

  @Column({
    type: 'enum',
    enum: MessageRole,
    default: MessageRole.USER,
  })
  role: MessageRole;

  @Column({ type: 'text', name: 'user_message' })
  userMessage: string;

  @Column({ type: 'jsonb', name: 'ai_response', nullable: true })
  aiResponse: Record<string, any> | null;

  @Column({ type: 'integer', name: 'token_usage', default: 0 })
  tokenUsage: number;

  @Column({ type: 'varchar', length: 50, name: 'provider_name', default: 'GEMINI' })
  providerName: string;

  @Column({ type: 'integer', name: 'response_time_ms', default: 0 })
  responseTimeMs: number;
}
