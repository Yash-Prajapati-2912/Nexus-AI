import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { GeminiFinanceProvider } from '../providers/gemini-finance.provider';
import { IAIFinancePromptContext } from '../interfaces/ai-finance-prompt-context.interface';

describe('GeminiFinanceProvider', () => {
  let provider: GeminiFinanceProvider;

  const mockContext: IAIFinancePromptContext = {
    userId: '11111111-1111-1111-1111-111111111111',
    budget: { plannedAmount: 500, spentAmount: 200, remainingAmount: 300 } as any,
    incomes: [{ amount: 800, receivedDate: new Date() }] as any,
    expenses: [{ amount: 50, expenseDate: new Date() }] as any,
    savingsGoals: [],
    categories: [],
    totalIncome: 800,
    totalExpenses: 50,
    remainingBudget: 300,
    daysRemainingInMonth: 15,
  };

  beforeEach(async () => {
    const mockConfig = {
      get: jest.fn().mockImplementation((key: string) => {
        if (key === 'gemini.apiKey') return 'dev_gemini_api_key_placeholder';
        if (key === 'gemini.model') return 'gemini-1.5-flash';
        return null;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GeminiFinanceProvider,
        { provide: ConfigService, useValue: mockConfig },
      ],
    }).compile();

    provider = module.get<GeminiFinanceProvider>(GeminiFinanceProvider);
  });

  it('should be defined', () => {
    expect(provider).toBeDefined();
    expect(provider.providerName).toBe('GEMINI');
  });

  it('should generate analysis fallback response cleanly when API key is unconfigured', async () => {
    const res = await provider.generateFinancialAnalysis('test prompt', mockContext);
    expect(res.summary).toBeDefined();
    expect(res.recommendations.length).toBeGreaterThan(0);
    expect(res.confidenceScore).toBe(0.85);
  });

  it('should generate fallback month-end prediction', async () => {
    const res = await provider.predictMonthEndBalance('test prompt', mockContext);
    expect(res.predictedMonthEndBalance).toBeDefined();
    expect(res.confidenceScore).toBe(0.85);
  });

  it('should calculate fallback safe daily budget with math reasoning', async () => {
    const res = await provider.calculateSafeDailyBudget('test prompt', mockContext);
    expect(res.safeDailyLimit).toBeGreaterThan(0);
    expect(res.mathematicalReasoning).toContain('Safe Daily Limit');
  });
});
