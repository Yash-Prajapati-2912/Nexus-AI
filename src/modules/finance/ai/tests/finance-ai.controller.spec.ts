import { Test, TestingModule } from '@nestjs/testing';
import { FinanceAIController } from '../controllers/finance-ai.controller';
import { FinanceAIService } from '../services/finance-ai.service';

describe('FinanceAIController', () => {
  let controller: FinanceAIController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockAIService = {
      generateFinancialSummary: jest.fn().mockResolvedValue({ summary: 'Summary OK' }),
      analyzeSpendingHabits: jest.fn().mockResolvedValue({ summary: 'Habits OK' }),
      predictMonthEndBalance: jest.fn().mockResolvedValue({ predictedMonthEndBalance: 250 }),
      calculateSafeDailyBudget: jest.fn().mockResolvedValue({ safeDailyLimit: 15 }),
      generateSavingsPlan: jest.fn().mockResolvedValue({ title: 'Plan OK' }),
      forecastExpenses: jest.fn().mockResolvedValue({ totalForecastedAmount: 100 }),
      generateFinancialReview: jest.fn().mockResolvedValue({ summary: 'Review OK' }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [FinanceAIController],
      providers: [{ provide: FinanceAIService, useValue: mockAIService }],
    }).compile();

    controller = module.get<FinanceAIController>(FinanceAIController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call generateFinancialSummary endpoint', async () => {
    const res = await controller.generateFinancialSummary(mockUserId, {});
    expect(res.summary).toBe('Summary OK');
  });

  it('should call calculateSafeDailyBudget endpoint', async () => {
    const res = await controller.calculateSafeDailyBudget(mockUserId, {});
    expect(res.safeDailyLimit).toBe(15);
  });

  it('should call generateFinancialReview endpoint with reviewType', async () => {
    const res = await controller.generateFinancialReview(mockUserId, { reviewType: 'SUBSCRIPTIONS' });
    expect(res.summary).toBe('Review OK');
  });
});
