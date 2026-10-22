import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ConversationType } from '../constants/mentor-enums.constants';

export class MessageItemDto {
  @ApiProperty({ description: 'Message ID' })
  id: string;

  @ApiPropertyOptional({ description: 'Conversation UUID' })
  conversationId?: string;

  @ApiProperty({ description: 'Role (USER, ASSISTANT, SYSTEM)' })
  role: string;

  @ApiProperty({ description: 'User message' })
  userMessage: string;

  @ApiPropertyOptional({ description: 'Normalized message text content' })
  content?: string;

  @ApiPropertyOptional({ description: 'Executive summary for assistant responses' })
  summary?: string;

  @ApiPropertyOptional({ description: 'Structured AI response payload' })
  aiResponse?: Record<string, any> | null;

  @ApiProperty({ description: 'Timestamp' })
  createdAt: Date;
}

export class ConversationResponseDto {
  @ApiProperty({ description: 'Conversation UUID' })
  id: string;

  @ApiProperty({ description: 'Title' })
  title: string;

  @ApiProperty({ description: 'Conversation Type', enum: ConversationType })
  conversationType: ConversationType;

  @ApiProperty({ description: 'Is archived' })
  isArchived: boolean;

  @ApiProperty({ description: 'Is pinned' })
  isPinned: boolean;

  @ApiPropertyOptional({ description: 'Tags', type: [String] })
  tags?: string[] | null;

  @ApiProperty({ description: 'Created At timestamp' })
  createdAt: Date;

  @ApiProperty({ description: 'Updated At timestamp' })
  updatedAt: Date;

  @ApiPropertyOptional({ description: 'Total message count' })
  messageCount?: number;

  @ApiPropertyOptional({ description: 'Snippet of the last message' })
  lastMessageSnippet?: string;

  @ApiPropertyOptional({ description: 'Messages list', type: [MessageItemDto] })
  messages?: MessageItemDto[];
}
