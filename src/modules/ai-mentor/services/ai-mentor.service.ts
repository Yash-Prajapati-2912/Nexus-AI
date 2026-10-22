import { Injectable, Logger, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AIMentorProviderFactory } from '../providers/ai-mentor-provider.factory';
import { ContextEngineService } from '../context/context-engine.service';
import { MentorMemoryEngineService } from '../memory/mentor-memory-engine.service';
import { MentorPromptBuilder } from '../builders/mentor-prompt.builder';
import { ConversationRepository } from '../repositories/conversation.repository';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationContextRepository } from '../repositories/conversation-context.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { MentorFeedbackRepository } from '../repositories/mentor-feedback.repository';
import { AIUsageLogRepository } from '../repositories/ai-usage-log.repository';
import { AIMentorCacheService } from './ai-mentor-cache.service';
import { AIMentorQueueProcessor } from '../queue/ai-mentor.queue';

import { ChatRequestDto } from '../dto/chat-request.dto';
import { ChatResponseDto } from '../dto/chat-response.dto';
import { ConversationQueryDto } from '../dto/conversation-query.dto';
import { ConversationResponseDto, MessageItemDto } from '../dto/conversation-response.dto';
import { UpdateConversationDto } from '../dto/update-conversation.dto';
import { MentorFeatureRequestDto } from '../dto/mentor-feature-request.dto';
import { MessageFeedbackDto } from '../dto/message-feedback.dto';
import { ConversationType, MessageRole, MentorRecommendationPriority } from '../constants/mentor-enums.constants';
import { MentorMapper } from '../mappers/mentor.mapper';
import { ConversationCreatedEvent } from '../events/conversation-created.event';
import { RecommendationGeneratedEvent } from '../events/recommendation-generated.event';

@Injectable()
export class AIMentorService {
  private readonly logger = new Logger(AIMentorService.name);

  constructor(
    private readonly providerFactory: AIMentorProviderFactory,
    private readonly contextEngine: ContextEngineService,
    private readonly memoryEngine: MentorMemoryEngineService,
    private readonly conversationRepository: ConversationRepository,
    private readonly messageRepository: ConversationMessageRepository,
    private readonly contextRepository: ConversationContextRepository,
    private readonly recommendationRepository: MentorRecommendationRepository,
    private readonly feedbackRepository: MentorFeedbackRepository,
    private readonly usageLogRepository: AIUsageLogRepository,
    private readonly cacheService: AIMentorCacheService,
    private readonly queueProcessor: AIMentorQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async chat(userId: string, dto: ChatRequestDto): Promise<ChatResponseDto> {
    const startTime = Date.now();
    let conversation: any;

    const userMessage = dto.message || dto.prompt || '';
    const resolvedType = (dto.conversationType && dto.conversationType !== ConversationType.GENERAL)
      ? dto.conversationType
      : (dto.topic && (ConversationType as any)[dto.topic.toUpperCase()]
          ? (ConversationType as any)[dto.topic.toUpperCase()]
          : (dto.conversationType || ConversationType.GENERAL));

    if (dto.conversationId) {
      conversation = await this.conversationRepository.findById(dto.conversationId);
      if (!conversation) throw new NotFoundException('Conversation not found');
      if (conversation.userId !== userId) throw new ForbiddenException('Access denied to conversation');
      conversation.updatedAt = new Date();
      await this.conversationRepository.save(conversation, userId);
    } else {
      const generatedTitle = userMessage.length > 30 ? `${userMessage.substring(0, 30)}...` : (userMessage || 'New Conversation');
      conversation = this.conversationRepository.create(
        {
          userId,
          title: generatedTitle,
          conversationType: resolvedType,
          isArchived: false,
          isPinned: false,
          tags: [resolvedType],
        },
        userId,
      );
      conversation = await this.conversationRepository.save(conversation, userId);
      this.eventEmitter.emit(
        'mentor.conversation_created',
        new ConversationCreatedEvent(conversation.id, userId, conversation.title, conversation.conversationType),
      );
    }

    const context = await this.contextEngine.buildUserContext(userId);
    context.shortTermMemoryTurns = await this.memoryEngine.getShortTermMemory(conversation.id);

    const provider = this.providerFactory.getProvider(dto.provider);
    const prompt = new MentorPromptBuilder()
      .setContext(context)
      .setUserMessage(userMessage)
      .setMentorDomain(conversation.conversationType)
      .build();

    const structuredRes = await provider.generateMentorResponse(prompt, context);

    // Save user message & AI response turn
    const userMsg = this.messageRepository.create(
      {
        conversationId: conversation.id,
        role: MessageRole.USER,
        userMessage: userMessage,
        aiResponse: null,
        tokenUsage: 100,
        providerName: provider.providerName,
        responseTimeMs: 0,
      },
      userId,
    );
    await this.messageRepository.save(userMsg, userId);

    const aiMsg = this.messageRepository.create(
      {
        conversationId: conversation.id,
        role: MessageRole.ASSISTANT,
        userMessage: dto.message,
        aiResponse: structuredRes as any,
        tokenUsage: 350,
        providerName: provider.providerName,
        responseTimeMs: Date.now() - startTime,
      },
      userId,
    );
    const savedAiMsg = await this.messageRepository.save(aiMsg, userId);

    // Save context snapshot
    const ctxSnapshot = this.contextRepository.create(
      {
        conversationId: conversation.id,
        contextSnapshot: context as any,
        contextVersion: 1,
      },
      userId,
    );
    await this.contextRepository.save(ctxSnapshot, userId);

    // Persist top recommendation cards
    if (structuredRes.recommendations && structuredRes.recommendations.length > 0) {
      for (const rec of structuredRes.recommendations) {
        const recEntity = this.recommendationRepository.create(
          {
            userId,
            title: rec.title,
            description: rec.description,
            priority: (rec.priority as MentorRecommendationPriority) || MentorRecommendationPriority.MEDIUM,
            domainCategory: rec.domainCategory || conversation.conversationType,
            isApplied: false,
          },
          userId,
        );
        const savedRec = await this.recommendationRepository.save(recEntity, userId);
        this.eventEmitter.emit(
          'mentor.recommendation_generated',
          new RecommendationGeneratedEvent(savedRec.id, userId, savedRec.title, savedRec.domainCategory),
        );
      }
    }

    await this.logUsage(userId, provider.providerName, 'CHAT', Date.now() - startTime);

    return MentorMapper.toChatResponseDto(conversation.id, savedAiMsg.id, structuredRes, provider.providerName);
  }

  async careerMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || dto.message || dto.prompt || 'Provide career development and skill optimization advice.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.CAREER,
    });
  }

  async studyMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || dto.message || dto.prompt || 'Help me plan my study schedule and prepare for academic milestones.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.STUDY,
    });
  }

  async decisionMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || dto.message || dto.prompt || 'Analyze my current choices and guide me through a structured decision framework.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.DECISION,
    });
  }

  async productivityMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || dto.message || dto.prompt || 'Help me optimize my weekly focus hours and time management.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.PRODUCTIVITY,
    });
  }

  async financeMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || dto.message || dto.prompt || 'Review my student budget and give me actionable financial coaching.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.FINANCE,
    });
  }

  async getUserConversations(userId: string, queryDto: ConversationQueryDto): Promise<ConversationResponseDto[]> {
    const convs = await this.conversationRepository.findUserConversations(userId, {
      type: queryDto.type,
      search: queryDto.search,
      isArchived: queryDto.isArchived,
      isPinned: queryDto.isPinned,
      limit: queryDto.limit,
      offset: queryDto.offset,
      page: queryDto.page,
    });

    return convs.map(MentorMapper.toConversationDto);
  }

  async getConversationById(userId: string, id: string): Promise<ConversationResponseDto> {
    const conv = await this.conversationRepository.findById(id);
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.userId !== userId) throw new ForbiddenException('Access denied');

    const messages = await this.messageRepository.findConversationMessages(id, 100);
    conv.messages = messages;

    return MentorMapper.toConversationDto(conv);
  }

  async getConversationMessages(userId: string, id: string): Promise<MessageItemDto[]> {
    const conv = await this.conversationRepository.findById(id);
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.userId !== userId) throw new ForbiddenException('Access denied');

    const messages = await this.messageRepository.findConversationMessages(id, 100);
    return messages.map(MentorMapper.toMessageDto);
  }

  async updateConversation(userId: string, id: string, dto: UpdateConversationDto): Promise<ConversationResponseDto> {
    const conv = await this.conversationRepository.findById(id);
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.userId !== userId) throw new ForbiddenException('Access denied');

    if (dto.title !== undefined) conv.title = dto.title;
    if (dto.isPinned !== undefined) conv.isPinned = dto.isPinned;
    if (dto.isArchived !== undefined) conv.isArchived = dto.isArchived;
    if (dto.tags !== undefined) conv.tags = dto.tags;

    const saved = await this.conversationRepository.save(conv, userId);
    return MentorMapper.toConversationDto(saved);
  }

  async deleteConversation(userId: string, id: string): Promise<{ success: boolean }> {
    const conv = await this.conversationRepository.findById(id);
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.userId !== userId) throw new ForbiddenException('Access denied');

    await this.conversationRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async submitMessageFeedback(
    userId: string,
    messageId: string,
    dto: MessageFeedbackDto,
  ): Promise<{ success: boolean; feedbackId: string; updated: boolean }> {
    const resolvedRating = dto.rating ?? (dto.isHelpful === false ? 1 : 5);
    if (resolvedRating < 1 || resolvedRating > 5) {
      throw new BadRequestException('Rating must be between 1 and 5');
    }

    const message = await this.messageRepository.findById(messageId);
    if (!message) {
      throw new NotFoundException('Message not found');
    }

    if (message.role !== MessageRole.ASSISTANT) {
      throw new BadRequestException('Feedback can only be submitted for assistant messages');
    }

    const conversation = await this.conversationRepository.findById(message.conversationId);
    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }
    if (conversation.userId !== userId) {
      throw new ForbiddenException('Access denied to conversation message');
    }

    const commentsText = dto.comment ?? dto.comments ?? null;

    // Check for existing feedback record to avoid duplicates
    const existing = await this.feedbackRepository.findOne({
      where: { userId, messageId },
    });

    if (existing) {
      existing.ratingScore = resolvedRating;
      existing.comments = commentsText;
      const updated = await this.feedbackRepository.save(existing, userId);
      return { success: true, feedbackId: updated.id, updated: true };
    }

    const newFeedback = this.feedbackRepository.create(
      {
        userId,
        messageId,
        ratingScore: resolvedRating,
        comments: commentsText,
      },
      userId,
    );
    const saved = await this.feedbackRepository.save(newFeedback, userId);
    return { success: true, feedbackId: saved.id, updated: false };
  }

  private async logUsage(userId: string, providerName: string, operationType: string, latencyMs: number): Promise<void> {
    const log = this.usageLogRepository.create(
      {
        userId,
        providerName,
        operationType,
        promptTokenCount: 180,
        candidatesTokenCount: 320,
        latencyMs,
        isFallback: false,
      },
      userId,
    );
    await this.usageLogRepository.save(log, userId);
  }
}
