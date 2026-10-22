import { Conversation } from '../entities/conversation.entity';
import { ConversationMessage } from '../entities/conversation-message.entity';
import { ConversationResponseDto, MessageItemDto } from '../dto/conversation-response.dto';
import { ChatResponseDto } from '../dto/chat-response.dto';
import { IAIMentorStructuredResponse } from '../interfaces/ai-mentor-response.interface';

export class MentorMapper {
  static toMessageDto(entity: ConversationMessage): MessageItemDto {
    let summary: string | undefined;
    let content: string = entity.userMessage || '';

    if (entity.role === 'ASSISTANT') {
      const ai: any = entity.aiResponse;
      if (ai && typeof ai === 'object') {
        summary = ai.summary || ai.content || ai.text;
        content = summary || entity.userMessage || '';
      } else if (typeof ai === 'string' && ai.trim().length > 0) {
        summary = ai;
        content = ai;
      }
    }

    return {
      id: entity.id,
      conversationId: entity.conversationId,
      role: entity.role,
      userMessage: entity.userMessage,
      content,
      summary,
      aiResponse: entity.aiResponse,
      createdAt: entity.createdAt,
    };
  }

  static toConversationDto(entity: Conversation): ConversationResponseDto {
    const rawMessages = entity.messages ? entity.messages.map(MentorMapper.toMessageDto) : undefined;
    if (rawMessages && rawMessages.length > 1) {
      rawMessages.sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());
    }

    let lastSnippet: string | undefined;
    if (rawMessages && rawMessages.length > 0) {
      const last = rawMessages[rawMessages.length - 1];
      if (last.role === 'USER') {
        lastSnippet = last.userMessage;
      } else if (last.summary) {
        lastSnippet = last.summary;
      } else if (last.content) {
        lastSnippet = last.content;
      } else {
        lastSnippet = last.userMessage;
      }
    }

    return {
      id: entity.id,
      title: entity.title,
      conversationType: entity.conversationType,
      isArchived: entity.isArchived,
      isPinned: entity.isPinned,
      tags: entity.tags || [],
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      messageCount: rawMessages ? rawMessages.length : 0,
      lastMessageSnippet: lastSnippet || 'No messages yet.',
      messages: rawMessages,
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
