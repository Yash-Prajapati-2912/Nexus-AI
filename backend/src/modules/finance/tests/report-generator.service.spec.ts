import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ReportGeneratorService } from '../reports/services/report-generator.service';
import { FinancialReportRepository } from '../repositories/financial-report.repository';
import { FinanceDataAggregator } from '../analytics/aggregators/finance-data.aggregator';
import { ExportFormat, ReportType } from '../constants/analytics-enums.constants';

describe('ReportGeneratorService', () => {
  let service: ReportGeneratorService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockReportRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'rep-1', createdAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
      findUserReports: jest.fn().mockResolvedValue([]),
    };

    const mockAggregator = {
      aggregatePeriodData: jest.fn().mockResolvedValue({
        expenses: [{ amount: 50, expenseDate: new Date() }],
        incomes: [{ amount: 200, receivedDate: new Date() }],
        budget: { plannedAmount: 500, spentAmount: 50, remainingAmount: 450, status: 'ACTIVE' },
        savingsGoals: [],
      }),
    };

    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportGeneratorService,
        { provide: FinancialReportRepository, useValue: mockReportRepo },
        { provide: FinanceDataAggregator, useValue: mockAggregator },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<ReportGeneratorService>(ReportGeneratorService);
  });

  it('should generate monthly report payload', async () => {
    const res = await service.generateReport(mockUserId, {
      reportType: ReportType.MONTHLY,
      format: ExportFormat.JSON,
    });

    expect(res.id).toBe('rep-1');
    expect(res.summaryData.spending.totalExpenses).toBe(50);
    expect(res.summaryData.cashFlow.totalInflow).toBe(200);
  });
});
