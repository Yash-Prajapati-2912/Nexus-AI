import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AIMentorService } from '../services/ai-mentor.service';
import { AIMentorProviderFactory } from '../providers/ai-mentor-provider.factory';
import { ContextEngineService } from '../context/context-engine.service';
import { MentorMemoryEngineService } from '../memory/mentor-memory-engine.service';
import { ConversationRepository } from '../repositories/conversation.repository';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationContextRepository } from '../repositories/conversation-context.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { AIUsageLogRepository } from '../repositories/ai-usage-log.repository';
import { AIMentorCacheService } from '../services/ai-mentor-cache.service';
import { AIMentorQueueProcessor } from '../queue/ai-mentor.queue';
import { ConversationType } from '../constants/mentor-enums.constants';

describe('AIMentorService', () => {
  let service: AIMentorService;

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

    const mockConvRepo = {
      findById: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'c-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
      findUserConversations: jest.fn().mockResolvedValue([]),
    };

    const mockMessageRepo = {
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
});
