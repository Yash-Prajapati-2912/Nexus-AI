import { Test, TestingModule } from '@nestjs/testing';
import { FinancialAnalyticsService } from '../services/financial-analytics.service';
import { FinanceDataAggregator } from '../analytics/aggregators/finance-data.aggregator';
import { ExpenseRepository } from '../repositories/expense.repository';
import { FinancialMetricRepository } from '../repositories/financial-metric.repository';

describe('FinancialAnalyticsService', () => {
  let service: FinancialAnalyticsService;
  let aggregator: jest.Mocked<FinanceDataAggregator>;
  let expenseRepo: jest.Mocked<ExpenseRepository>;
  let metricRepo: jest.Mocked<FinancialMetricRepository>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockAggregator = {
      aggregatePeriodData: jest.fn().mockResolvedValue({
        expenses: [
          { amount: 50, expenseDate: new Date('2026-09-10T10:00:00Z'), categoryId: 'cat-1' },
          { amount: 150, expenseDate: new Date('2026-09-15T10:00:00Z'), categoryId: 'cat-1' },
        ],
        incomes: [{ amount: 500, receivedDate: new Date('2026-09-01T10:00:00Z') }],
        budget: { plannedAmount: 400, remainingAmount: 200 },
        savingsGoals: [{ targetAmount: 1000, currentAmount: 500 }],
      }),
    };

    const mockExpenseRepo = {
      getCategoryBreakdownForPeriod: jest.fn().mockResolvedValue([
        { categoryId: 'cat-1', categoryName: 'Food', colour: '#EF4444', icon: 'utensils', totalAmount: 200, percentage: 100 },
      ]),
    };

    const mockMetricRepo = {
      upsertMetric: jest.fn().mockResolvedValue(undefined),
      findUserMetrics: jest.fn().mockResolvedValue([]),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FinancialAnalyticsService,
        { provide: FinanceDataAggregator, useValue: mockAggregator },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: FinancialMetricRepository, useValue: mockMetricRepo },
      ],
    }).compile();

    service = module.get<FinancialAnalyticsService>(FinancialAnalyticsService);
    aggregator = module.get(FinanceDataAggregator);
    expenseRepo = module.get(ExpenseRepository);
    metricRepo = module.get(FinancialMetricRepository);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should calculate analytics overview stats accurately', async () => {
    const res = await service.getAnalytics(mockUserId, {});

    expect(res.overview.totalIncome).toBe(500);
    expect(res.overview.totalExpenses).toBe(200);
    expect(res.overview.netBalance).toBe(300);
    expect(res.overview.highestExpense).toBe(150);
    expect(res.overview.lowestExpense).toBe(50);
    expect(res.overview.budgetUtilisation).toBe(50);
  });
});
