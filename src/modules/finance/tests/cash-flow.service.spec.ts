import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { CashFlowService } from '../services/cash-flow.service';
import { FinanceDataAggregator } from '../analytics/aggregators/finance-data.aggregator';
import { CashFlowSummaryRepository } from '../repositories/cash-flow-summary.repository';

describe('CashFlowService', () => {
  let service: CashFlowService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockAggregator = {
      aggregatePeriodData: jest.fn().mockResolvedValue({
        expenses: [{ amount: 100, expenseDate: new Date('2026-09-05T10:00:00Z') }],
        incomes: [{ amount: 300, receivedDate: new Date('2026-09-01T10:00:00Z') }],
      }),
    };

    const mockCashFlowRepo = {
      findLatestForUser: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'cf-1' })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CashFlowService,
        { provide: FinanceDataAggregator, useValue: mockAggregator },
        { provide: CashFlowSummaryRepository, useValue: mockCashFlowRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<CashFlowService>(CashFlowService);
  });

  it('should compute cash flow totals', async () => {
    const res = await service.getCashFlow(mockUserId, {});

    expect(res.totalInflow).toBe(300);
    expect(res.totalOutflow).toBe(100);
    expect(res.netCashFlow).toBe(200);
  });
});
