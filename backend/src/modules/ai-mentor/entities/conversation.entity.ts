import { Entity, Column, Index, OneToMany } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { ConversationType } from '../constants/mentor-enums.constants';
import { ConversationMessage } from './conversation-message.entity';

/**
 * Conversation Entity.
 * Tracks user mentor chat sessions, type, tags, pinned, and archived states.
 */
@Entity('ai_mentor_conversations')
@Index('idx_mentor_conversations_user', ['userId', 'isArchived', 'isPinned'])
export class Conversation extends BaseEntity {
  @Index('idx_mentor_conversations_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({
    type: 'enum',
    enum: ConversationType,
    default: ConversationType.GENERAL,
    name: 'conversation_type',
  })
  conversationType: ConversationType;

  @Column({ type: 'boolean', name: 'is_archived', default: false })
  isArchived: boolean;

  @Column({ type: 'boolean', name: 'is_pinned', default: false })
  isPinned: boolean;

  @Column({ type: 'simple-array', nullable: true })
  tags: string[] | null;

  @OneToMany(() => ConversationMessage, (msg) => msg.conversation)
  messages: ConversationMessage[];
}
