import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MonthlySummaryService } from '../services/monthly-summary.service';
import { MonthlySummaryRepository } from '../repositories/monthly-summary.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { IncomeRepository } from '../repositories/income.repository';
import { BudgetRepository } from '../repositories/budget.repository';

describe('MonthlySummaryService', () => {
  let service: MonthlySummaryService;
  let summaryRepo: jest.Mocked<MonthlySummaryRepository>;
  let expenseRepo: jest.Mocked<ExpenseRepository>;
  let incomeRepo: jest.Mocked<IncomeRepository>;
  let budgetRepo: jest.Mocked<BudgetRepository>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockSummaryRepo = {
      findByUserAndPeriod: jest.fn(),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'summary-id', createdAt: new Date(), updatedAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
    };

    const mockExpenseRepo = {
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(300),
      getCategoryBreakdownForPeriod: jest.fn().mockResolvedValue([
        {
          categoryId: 'cat-1',
          categoryName: 'Food & Dining',
          colour: '#EF4444',
          icon: 'utensils',
          totalAmount: 300,
          percentage: 100,
        },
      ]),
    };

    const mockIncomeRepo = {
      calculateTotalIncomeForPeriod: jest.fn().mockResolvedValue(1000),
    };

    const mockBudgetRepo = {
      findByUserAndPeriod: jest.fn().mockResolvedValue({ plannedAmount: 500 }),
    };

    const mockEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MonthlySummaryService,
        { provide: MonthlySummaryRepository, useValue: mockSummaryRepo },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: IncomeRepository, useValue: mockIncomeRepo },
        { provide: BudgetRepository, useValue: mockBudgetRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<MonthlySummaryService>(MonthlySummaryService);
    summaryRepo = module.get(MonthlySummaryRepository);
    expenseRepo = module.get(ExpenseRepository);
    incomeRepo = module.get(IncomeRepository);
    budgetRepo = module.get(BudgetRepository);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('recalculateSummary', () => {
    it('should compute correct monthly stats', async () => {
      summaryRepo.findByUserAndPeriod.mockResolvedValue(null);

      const result = await service.recalculateSummary(mockUserId, 9, 2026);

      expect(result.totalIncome).toBe(1000);
      expect(result.totalExpenses).toBe(300);
      expect(result.savings).toBe(700);
      expect(result.remainingBudget).toBe(200); // 500 planned - 300 spent
      expect(result.budgetUtilisationPercentage).toBe(60); // 300 / 500 * 100
    });
  });
});
