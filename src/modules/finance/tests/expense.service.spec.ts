import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotFoundException } from '@nestjs/common';
import { ExpenseService } from '../services/expense.service';
import { ExpenseRepository } from '../repositories/expense.repository';
import { ExpenseCategoryRepository } from '../repositories/expense-category.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { BudgetService } from '../services/budget.service';
import { PaymentMethod } from '../constants/finance-enums.constants';

describe('ExpenseService', () => {
  let service: ExpenseService;
  let expenseRepo: jest.Mocked<ExpenseRepository>;
  let categoryRepo: jest.Mocked<ExpenseCategoryRepository>;
  let budgetService: jest.Mocked<BudgetService>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';
  const mockCategoryId = '33333333-3333-3333-3333-333333333333';
  const mockExpenseId = '55555555-5555-5555-5555-555555555555';

  const mockCategory: any = {
    id: mockCategoryId,
    userId: null,
    name: 'Food & Dining',
    isDefault: true,
    colour: '#EF4444',
    icon: 'utensils',
  };

  const mockExpense: any = {
    id: mockExpenseId,
    userId: mockUserId,
    budgetId: null,
    categoryId: mockCategoryId,
    category: mockCategory,
    title: 'Lunch at Commons',
    amount: 15.5,
    expenseDate: new Date('2026-09-10T12:00:00Z'),
    paymentMethod: PaymentMethod.DEBIT_CARD,
    isRecurring: false,
    tags: ['food'],
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockExpenseRepository = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: mockExpenseId, createdAt: new Date(), updatedAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
      findById: jest.fn(),
      findFilteredExpenses: jest.fn(),
      softDeleteById: jest.fn().mockResolvedValue(true),
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(15.5),
    };

    const mockCategoryRepository = {
      findById: jest.fn(),
    };

    const mockBudgetRepository = {
      findActiveByUserAndPeriod: jest.fn().mockResolvedValue(null),
      findById: jest.fn().mockResolvedValue(null),
    };

    const mockBudgetService = {
      updateBudgetSpentAmount: jest.fn().mockResolvedValue(undefined),
    };

    const mockEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ExpenseService,
        { provide: ExpenseRepository, useValue: mockExpenseRepository },
        { provide: ExpenseCategoryRepository, useValue: mockCategoryRepository },
        { provide: BudgetRepository, useValue: mockBudgetRepository },
        { provide: BudgetService, useValue: mockBudgetService },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<ExpenseService>(ExpenseService);
    expenseRepo = module.get(ExpenseRepository);
    categoryRepo = module.get(ExpenseCategoryRepository);
    budgetService = module.get(BudgetService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createExpense', () => {
    it('should create an expense and recalculate budget spent amount', async () => {
      categoryRepo.findById.mockResolvedValue(mockCategory);

      const result = await service.createExpense(mockUserId, {
        categoryId: mockCategoryId,
        title: 'Lunch at Commons',
        amount: 15.5,
        expenseDate: '2026-09-10T12:00:00Z',
      });

      expect(result.amount).toBe(15.5);
      expect(budgetService.updateBudgetSpentAmount).toHaveBeenCalled();
    });

    it('should throw NotFoundException if category is invalid', async () => {
      categoryRepo.findById.mockResolvedValue(null);

      await expect(
        service.createExpense(mockUserId, {
          categoryId: mockCategoryId,
          title: 'Lunch',
          amount: 10,
          expenseDate: '2026-09-10T12:00:00Z',
        }),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('deleteExpense', () => {
    it('should soft delete expense and trigger recalculation', async () => {
      expenseRepo.findById.mockResolvedValue(mockExpense);

      const res = await service.deleteExpense(mockUserId, mockExpenseId);

      expect(res.success).toBe(true);
      expect(expenseRepo.softDeleteById).toHaveBeenCalledWith(mockExpenseId, mockUserId);
      expect(budgetService.updateBudgetSpentAmount).toHaveBeenCalled();
    });
  });
});
