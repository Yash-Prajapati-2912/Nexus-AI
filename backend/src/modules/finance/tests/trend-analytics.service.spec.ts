import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { TrendAnalyticsService } from '../services/trend-analytics.service';
import { FinancialTrendRepository } from '../repositories/financial-trend.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { IncomeRepository } from '../repositories/income.repository';
import { BudgetRepository } from '../repositories/budget.repository';

describe('TrendAnalyticsService', () => {
  let service: TrendAnalyticsService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockTrendRepo = {
      findOne: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 't-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
      findUserTrends: jest.fn().mockResolvedValue([
        {
          periodLabel: '2026-09',
          incomeGrowthPercentage: 10,
          expenseGrowthPercentage: 5,
          savingsGrowthPercentage: 15,
          budgetConsumptionRate: 80,
          netCashFlow: 400,
        },
      ]),
    };

    const mockExpenseRepo = { calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(200) };
    const mockIncomeRepo = { calculateTotalIncomeForPeriod: jest.fn().mockResolvedValue(600) };
    const mockBudgetRepo = { findByUserAndPeriod: jest.fn().mockResolvedValue({ plannedAmount: 500 }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TrendAnalyticsService,
        { provide: FinancialTrendRepository, useValue: mockTrendRepo },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: IncomeRepository, useValue: mockIncomeRepo },
        { provide: BudgetRepository, useValue: mockBudgetRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<TrendAnalyticsService>(TrendAnalyticsService);
  });

  it('should generate trend data points', async () => {
    const res = await service.getTrends(mockUserId, 'MONTHLY', 1);

    expect(res.trends.length).toBe(1);
    expect(res.trends[0].periodLabel).toBe('2026-09');
  });
});
