import { Conversation } from '../entities/conversation.entity';
import { ConversationMessage } from '../entities/conversation-message.entity';
import { ConversationResponseDto, MessageItemDto } from '../dto/conversation-response.dto';
import { ChatResponseDto } from '../dto/chat-response.dto';
import { IAIMentorStructuredResponse } from '../interfaces/ai-mentor-response.interface';

export class MentorMapper {
  static toMessageDto(entity: ConversationMessage): MessageItemDto {
    return {
      id: entity.id,
      role: entity.role,
      userMessage: entity.userMessage,
      aiResponse: entity.aiResponse,
      createdAt: entity.createdAt,
    };
  }

  static toConversationDto(entity: Conversation): ConversationResponseDto {
    return {
      id: entity.id,
      title: entity.title,
      conversationType: entity.conversationType,
      isArchived: entity.isArchived,
      isPinned: entity.isPinned,
      tags: entity.tags || [],
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      messages: entity.messages ? entity.messages.map(MentorMapper.toMessageDto) : undefined,
    };
  }

  static toChatResponseDto(
    conversationId: string,
    messageId: string,
    structured: IAIMentorStructuredResponse,
    providerName: string,
  ): ChatResponseDto {
    return {
      conversationId,
      messageId,
      summary: structured.summary,
      reasoning: structured.reasoning || [],
      recommendations: (structured.recommendations || []).map((r) => ({
        title: r.title,
        description: r.description,
        priority: r.priority,
        domainCategory: r.domainCategory,
      })),
      actionPlan: (structured.actionPlan || []).map((a) => ({
        step: a.step,
        title: a.title,
        description: a.description,
        targetDeadlineDays: a.targetDeadlineDays,
      })),
      confidenceScore: structured.confidenceScore,
      followUpQuestions: structured.followUpQuestions || [],
      providerName,
    };
  }
}
