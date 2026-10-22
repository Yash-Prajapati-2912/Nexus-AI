import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { AIMentorService } from '../services/ai-mentor.service';
import { AIMentorProviderFactory } from '../providers/ai-mentor-provider.factory';
import { ContextEngineService } from '../context/context-engine.service';
import { MentorMemoryEngineService } from '../memory/mentor-memory-engine.service';
import { ConversationRepository } from '../repositories/conversation.repository';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationContextRepository } from '../repositories/conversation-context.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { MentorFeedbackRepository } from '../repositories/mentor-feedback.repository';
import { AIUsageLogRepository } from '../repositories/ai-usage-log.repository';
import { AIMentorCacheService } from '../services/ai-mentor-cache.service';
import { AIMentorQueueProcessor } from '../queue/ai-mentor.queue';
import { ConversationType, MessageRole } from '../constants/mentor-enums.constants';

describe('AIMentorService', () => {
  let service: AIMentorService;
  let mockConvRepo: any;
  let mockMessageRepo: any;
  let mockFeedbackRepo: any;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockProvider = {
      providerName: 'GEMINI',
      generateMentorResponse: jest.fn().mockResolvedValue({
        summary: 'AI mentoring summary',
        reasoning: ['Reason 1'],
        recommendations: [{ title: 'Rec 1', description: 'Desc 1', priority: 'HIGH', domainCategory: 'CAREER' }],
        actionPlan: [{ step: 1, title: 'Step 1', description: 'Desc step' }],
        confidenceScore: 0.92,
        followUpQuestions: ['Next question?'],
      }),
    };

    const mockFactory = { getProvider: jest.fn().mockReturnValue(mockProvider) };
    const mockContextEngine = { buildUserContext: jest.fn().mockResolvedValue({ userId: mockUserId }) };
    const mockMemoryEngine = { getShortTermMemory: jest.fn().mockResolvedValue([]) };

    mockConvRepo = {
      findById: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'c-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
      findUserConversations: jest.fn().mockResolvedValue([]),
    };

    mockMessageRepo = {
      findById: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'm-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
      findConversationMessages: jest.fn().mockResolvedValue([]),
    };

    const mockCtxRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'ctx-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockRecRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'r-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    mockFeedbackRepo = {
      findOne: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'fb-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity, id: entity.id || 'fb-1' })),
    };

    const mockUsageRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'u-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined) };
    const mockQueue = { addSummarizationJob: jest.fn().mockResolvedValue({ jobId: 'j-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AIMentorService,
        { provide: AIMentorProviderFactory, useValue: mockFactory },
        { provide: ContextEngineService, useValue: mockContextEngine },
        { provide: MentorMemoryEngineService, useValue: mockMemoryEngine },
        { provide: ConversationRepository, useValue: mockConvRepo },
        { provide: ConversationMessageRepository, useValue: mockMessageRepo },
        { provide: ConversationContextRepository, useValue: mockCtxRepo },
        { provide: MentorRecommendationRepository, useValue: mockRecRepo },
        { provide: MentorFeedbackRepository, useValue: mockFeedbackRepo },
        { provide: AIUsageLogRepository, useValue: mockUsageRepo },
        { provide: AIMentorCacheService, useValue: mockCache },
        { provide: AIMentorQueueProcessor, useValue: mockQueue },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<AIMentorService>(AIMentorService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should process chat request and return structured response payload', async () => {
    const res = await service.chat(mockUserId, {
      message: 'Help me plan my career in AI',
      conversationType: ConversationType.CAREER,
    });

    expect(res.conversationId).toBe('c-1');
    expect(res.summary).toBe('AI mentoring summary');
    expect(res.recommendations.length).toBe(1);
    expect(res.confidenceScore).toBe(0.92);
  });

  it('should handle specialized career mentor request', async () => {
    const res = await service.careerMentor(mockUserId, { query: 'Career path advice' });
    expect(res.summary).toBe('AI mentoring summary');
  });

  describe('submitMessageFeedback', () => {
    const messageId = '22222222-2222-2222-2222-222222222222';
    const conversationId = '33333333-3333-3333-3333-333333333333';

    it('should reject invalid ratings outside 1..5', async () => {
      await expect(
        service.submitMessageFeedback(mockUserId, messageId, { rating: 0 }),
      ).rejects.toThrow(BadRequestException);

      await expect(
        service.submitMessageFeedback(mockUserId, messageId, { rating: 6 }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw NotFoundException if message is not found', async () => {
      mockMessageRepo.findById.mockResolvedValue(null);

      await expect(
        service.submitMessageFeedback(mockUserId, messageId, { rating: 5 }),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw BadRequestException if message is not an ASSISTANT message', async () => {
      mockMessageRepo.findById.mockResolvedValue({
        id: messageId,
        conversationId,
        role: MessageRole.USER,
      });

      await expect(
        service.submitMessageFeedback(mockUserId, messageId, { rating: 5 }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw ForbiddenException if conversation belongs to another user', async () => {
      mockMessageRepo.findById.mockResolvedValue({
        id: messageId,
        conversationId,
        role: MessageRole.ASSISTANT,
      });
      mockConvRepo.findById.mockResolvedValue({
        id: conversationId,
        userId: 'different-user-id',
      });

      await expect(
        service.submitMessageFeedback(mockUserId, messageId, { rating: 5 }),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should successfully persist new feedback record', async () => {
      mockMessageRepo.findById.mockResolvedValue({
        id: messageId,
        conversationId,
        role: MessageRole.ASSISTANT,
      });
      mockConvRepo.findById.mockResolvedValue({
        id: conversationId,
        userId: mockUserId,
      });
      mockFeedbackRepo.findOne.mockResolvedValue(null);

      const res = await service.submitMessageFeedback(mockUserId, messageId, {
        rating: 5,
        comment: 'Super helpful explanation!',
      });

      expect(res.success).toBe(true);
      expect(res.feedbackId).toBe('fb-1');
      expect(res.updated).toBe(false);
      expect(mockFeedbackRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          userId: mockUserId,
          messageId,
          ratingScore: 5,
          comments: 'Super helpful explanation!',
        }),
        mockUserId,
      );
    });

    it('should update existing feedback record to avoid duplicate records', async () => {
      mockMessageRepo.findById.mockResolvedValue({
        id: messageId,
        conversationId,
        role: MessageRole.ASSISTANT,
      });
      mockConvRepo.findById.mockResolvedValue({
        id: conversationId,
        userId: mockUserId,
      });
      const existingRecord = {
        id: 'fb-existing',
        userId: mockUserId,
        messageId,
        ratingScore: 3,
        comments: 'Old comment',
      };
      mockFeedbackRepo.findOne.mockResolvedValue(existingRecord);

      const res = await service.submitMessageFeedback(mockUserId, messageId, {
        rating: 4,
        comments: 'Updated comment',
      });

      expect(res.success).toBe(true);
      expect(res.feedbackId).toBe('fb-existing');
      expect(res.updated).toBe(true);
      expect(mockFeedbackRepo.save).toHaveBeenCalledWith(
        expect.objectContaining({
          id: 'fb-existing',
          ratingScore: 4,
          comments: 'Updated comment',
        }),
        mockUserId,
      );
    });
  });

  describe('Conversation Persistence & History Restoration', () => {
    const existingConvId = '44444444-4444-4444-4444-444444444444';

    it('should create new conversation and persist both user and assistant message records', async () => {
      const res = await service.chat(mockUserId, {
        message: 'How do I optimize my schedule?',
        conversationType: ConversationType.PRODUCTIVITY,
      });

      expect(res.conversationId).toBe('c-1');
      expect(mockConvRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          userId: mockUserId,
          conversationType: ConversationType.PRODUCTIVITY,
        }),
        mockUserId,
      );
      expect(mockConvRepo.save).toHaveBeenCalled();

      // Expect USER message saved
      expect(mockMessageRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          conversationId: 'c-1',
          role: MessageRole.USER,
          userMessage: 'How do I optimize my schedule?',
        }),
        mockUserId,
      );

      // Expect ASSISTANT message saved
      expect(mockMessageRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          conversationId: 'c-1',
          role: MessageRole.ASSISTANT,
        }),
        mockUserId,
      );
      expect(mockMessageRepo.save).toHaveBeenCalledTimes(2);
    });

    it('should continue an existing conversation and update conversation updatedAt timestamp', async () => {
      const oldUpdatedAt = new Date(2026, 6, 1);
      const existingConv = {
        id: existingConvId,
        userId: mockUserId,
        title: 'Schedule Optimization',
        conversationType: ConversationType.PRODUCTIVITY,
        isArchived: false,
        isPinned: false,
        updatedAt: oldUpdatedAt,
      };
      mockConvRepo.findById.mockResolvedValue(existingConv);

      const res = await service.chat(mockUserId, {
        message: 'What about weekend study blocks?',
        conversationId: existingConvId,
      });

      expect(res.conversationId).toBe(existingConvId);
      expect(existingConv.updatedAt.getTime()).toBeGreaterThan(oldUpdatedAt.getTime());
      expect(mockConvRepo.save).toHaveBeenCalledWith(existingConv, mockUserId);
      expect(mockMessageRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          conversationId: existingConvId,
          userMessage: 'What about weekend study blocks?',
        }),
        mockUserId,
      );
    });

    it('should prevent User B from continuing User A conversation (User Isolation)', async () => {
      mockConvRepo.findById.mockResolvedValue({
        id: existingConvId,
        userId: 'user-a-different',
      });

      await expect(
        service.chat(mockUserId, {
          message: 'Can I access this?',
          conversationId: existingConvId,
        }),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should restore conversation details and messages in order', async () => {
      const m1 = {
        id: 'msg-1',
        conversationId: existingConvId,
        role: MessageRole.USER,
        userMessage: 'First question',
        createdAt: new Date(2026, 6, 1, 10, 0),
      };
      const m2 = {
        id: 'msg-2',
        conversationId: existingConvId,
        role: MessageRole.ASSISTANT,
        userMessage: 'First question',
        aiResponse: { summary: 'First answer' },
        createdAt: new Date(2026, 6, 1, 10, 1),
      };

      mockConvRepo.findById.mockResolvedValue({
        id: existingConvId,
        userId: mockUserId,
        title: 'Study chat',
        conversationType: ConversationType.STUDY,
        isArchived: false,
        isPinned: true,
        createdAt: new Date(2026, 6, 1),
        updatedAt: new Date(2026, 6, 1),
      });
      mockMessageRepo.findConversationMessages.mockResolvedValue([m1, m2]);

      const conv = await service.getConversationById(mockUserId, existingConvId);

      expect(conv.id).toBe(existingConvId);
      expect(conv.messages?.length).toBe(2);
      expect(conv.messages?.[0].content).toBe('First question');
      expect(conv.messages?.[1].summary).toBe('First answer');
      expect(conv.isPinned).toBe(true);
    });

    it('should throw ForbiddenException if User B attempts to getConversationById for User A', async () => {
      mockConvRepo.findById.mockResolvedValue({
        id: existingConvId,
        userId: 'user-a-different',
      });

      await expect(
        service.getConversationById(mockUserId, existingConvId),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should retrieve conversation messages via getConversationMessages', async () => {
      mockConvRepo.findById.mockResolvedValue({
        id: existingConvId,
        userId: mockUserId,
      });
      mockMessageRepo.findConversationMessages.mockResolvedValue([
        {
          id: 'msg-1',
          conversationId: existingConvId,
          role: MessageRole.USER,
          userMessage: 'Hello',
          createdAt: new Date(),
        },
      ]);

      const msgs = await service.getConversationMessages(mockUserId, existingConvId);
      expect(msgs.length).toBe(1);
      expect(msgs[0].conversationId).toBe(existingConvId);
      expect(msgs[0].content).toBe('Hello');
    });
  });
});
