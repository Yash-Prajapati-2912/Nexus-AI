import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { FinanceAIService } from '../services/finance-ai.service';
import { AIFinanceProviderFactory } from '../providers/ai-finance-provider.factory';
import { FinanceDataAggregator } from '../../analytics/aggregators/finance-data.aggregator';
import { AIFinancialAnalysisRepository } from '../repositories/ai-financial-analysis.repository';
import { SpendingPredictionRepository } from '../repositories/spending-prediction.repository';
import { SavingsRecommendationRepository } from '../repositories/savings-recommendation.repository';
import { AIFinanceUsageLogRepository } from '../repositories/ai-finance-usage-log.repository';
import { FinanceAICacheService } from '../services/finance-ai-cache.service';
import { FinanceAIQueueProcessor } from '../queue/finance-ai.queue';

describe('FinanceAIService', () => {
  let service: FinanceAIService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockProvider = {
      providerName: 'GEMINI',
      generateFinancialAnalysis: jest.fn().mockResolvedValue({
        summary: 'Solid budget management',
        strengths: ['Low impulse spending'],
        weaknesses: [],
        recommendations: [],
        warnings: [],
        confidenceScore: 0.9,
      }),
      predictMonthEndBalance: jest.fn().mockResolvedValue({
        predictedMonthEndBalance: 300,
        expectedTotalSpending: 500,
        savingsAchievementProbability: 90,
        budgetExhaustionDate: null,
        reasoning: 'On track',
        confidenceScore: 0.9,
      }),
      calculateSafeDailyBudget: jest.fn().mockResolvedValue({
        safeDailyLimit: 20,
        remainingBudget: 300,
        remainingDays: 15,
        reservedSavings: 50,
        plannedUpcomingExpenses: 0,
        mathematicalReasoning: 'Math reasoning',
        behavioralGuidance: [],
        confidenceScore: 0.95,
      }),
    };

    const mockFactory = { getProvider: jest.fn().mockReturnValue(mockProvider) };

    const mockAggregator = {
      aggregatePeriodData: jest.fn().mockResolvedValue({
        expenses: [],
        incomes: [],
        budget: { plannedAmount: 500, remainingAmount: 300, spentAmount: 200 },
        savingsGoals: [],
      }),
    };

    const mockAnalysisRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'a-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockPredictionRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'p-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockSavingsRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 's-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockUsageLogRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'u-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockCacheService = {
      get: jest.fn().mockResolvedValue(null),
      set: jest.fn().mockResolvedValue(undefined),
    };

    const mockQueueProcessor = { addAnalysisJob: jest.fn().mockResolvedValue({ jobId: 'j-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FinanceAIService,
        { provide: AIFinanceProviderFactory, useValue: mockFactory },
        { provide: FinanceDataAggregator, useValue: mockAggregator },
        { provide: AIFinancialAnalysisRepository, useValue: mockAnalysisRepo },
        { provide: SpendingPredictionRepository, useValue: mockPredictionRepo },
        { provide: SavingsRecommendationRepository, useValue: mockSavingsRepo },
        { provide: AIFinanceUsageLogRepository, useValue: mockUsageLogRepo },
        { provide: FinanceAICacheService, useValue: mockCacheService },
        { provide: FinanceAIQueueProcessor, useValue: mockQueueProcessor },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<FinanceAIService>(FinanceAIService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should generate financial summary and log telemetry', async () => {
    const res = await service.generateFinancialSummary(mockUserId, {});
    expect(res.summary).toBe('Solid budget management');
    expect(res.providerName).toBe('GEMINI');
  });

  it('should predict month end balance', async () => {
    const res = await service.predictMonthEndBalance(mockUserId, {});
    expect(res.predictedMonthEndBalance).toBe(300);
  });

  it('should calculate safe daily budget', async () => {
    const res = await service.calculateSafeDailyBudget(mockUserId, {});
    expect(res.safeDailyLimit).toBe(20);
    expect(res.mathematicalReasoning).toBe('Math reasoning');
  });
});
