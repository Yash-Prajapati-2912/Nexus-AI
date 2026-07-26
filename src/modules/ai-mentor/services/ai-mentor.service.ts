import { Injectable, Logger, NotFoundException, ForbiddenException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AIMentorProviderFactory } from '../providers/ai-mentor-provider.factory';
import { ContextEngineService } from '../context/context-engine.service';
import { MentorMemoryEngineService } from '../memory/mentor-memory-engine.service';
import { MentorPromptBuilder } from '../builders/mentor-prompt.builder';
import { ConversationRepository } from '../repositories/conversation.repository';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationContextRepository } from '../repositories/conversation-context.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { AIUsageLogRepository } from '../repositories/ai-usage-log.repository';
import { AIMentorCacheService } from './ai-mentor-cache.service';
import { AIMentorQueueProcessor } from '../queue/ai-mentor.queue';

import { ChatRequestDto } from '../dto/chat-request.dto';
import { ChatResponseDto } from '../dto/chat-response.dto';
import { ConversationQueryDto } from '../dto/conversation-query.dto';
import { ConversationResponseDto } from '../dto/conversation-response.dto';
import { UpdateConversationDto } from '../dto/update-conversation.dto';
import { MentorFeatureRequestDto } from '../dto/mentor-feature-request.dto';
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
    private readonly usageLogRepository: AIUsageLogRepository,
    private readonly cacheService: AIMentorCacheService,
    private readonly queueProcessor: AIMentorQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async chat(userId: string, dto: ChatRequestDto): Promise<ChatResponseDto> {
    const startTime = Date.now();
    let conversation: any;

    if (dto.conversationId) {
      conversation = await this.conversationRepository.findById(dto.conversationId);
      if (!conversation) throw new NotFoundException('Conversation not found');
      if (conversation.userId !== userId) throw new ForbiddenException('Access denied to conversation');
    } else {
      const generatedTitle = dto.message.length > 30 ? `${dto.message.substring(0, 30)}...` : dto.message;
      conversation = this.conversationRepository.create(
        {
          userId,
          title: generatedTitle,
          conversationType: dto.conversationType || ConversationType.GENERAL,
          isArchived: false,
          isPinned: false,
          tags: [dto.conversationType || 'GENERAL'],
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
      .setUserMessage(dto.message)
      .setMentorDomain(conversation.conversationType)
      .build();

    const structuredRes = await provider.generateMentorResponse(prompt, context);

    // Save user message & AI response turn
    const userMsg = this.messageRepository.create(
      {
        conversationId: conversation.id,
        role: MessageRole.USER,
        userMessage: dto.message,
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
      message: dto.query || 'Provide career development and skill optimization advice.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.CAREER,
    });
  }

  async studyMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || 'Help me plan my study schedule and prepare for academic milestones.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.STUDY,
    });
  }

  async decisionMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || 'Analyze my current choices and guide me through a structured decision framework.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.DECISION,
    });
  }

  async productivityMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || 'Help me optimize my weekly focus hours and time management.',
      conversationId: dto.conversationId,
      conversationType: ConversationType.PRODUCTIVITY,
    });
  }

  async financeMentor(userId: string, dto: MentorFeatureRequestDto): Promise<ChatResponseDto> {
    return this.chat(userId, {
      message: dto.query || 'Review my student budget and give me actionable financial coaching.',
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
