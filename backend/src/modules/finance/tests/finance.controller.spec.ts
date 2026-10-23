import { Test, TestingModule } from '@nestjs/testing';
import { BudgetController } from '../controllers/budget.controller';
import { ExpenseController } from '../controllers/expense.controller';
import { IncomeController } from '../controllers/income.controller';
import { SavingsGoalController } from '../controllers/savings-goal.controller';
import { MonthlySummaryController } from '../controllers/monthly-summary.controller';
import { ExpenseCategoryController } from '../controllers/expense-category.controller';

import { BudgetService } from '../services/budget.service';
import { ExpenseService } from '../services/expense.service';
import { IncomeService } from '../services/income.service';
import { SavingsGoalService } from '../services/savings-goal.service';
import { MonthlySummaryService } from '../services/monthly-summary.service';
import { ExpenseCategoryService } from '../services/expense-category.service';

describe('Finance Controllers', () => {
  let budgetController: BudgetController;
  let expenseController: ExpenseController;
  let incomeController: IncomeController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockBudgetService = {
      createBudget: jest.fn().mockResolvedValue({ id: 'b-1', plannedAmount: 1000 }),
      getUserBudgets: jest.fn().mockResolvedValue([]),
      getBudgetById: jest.fn().mockResolvedValue({ id: 'b-1' }),
    };

    const mockExpenseService = {
      createExpense: jest.fn().mockResolvedValue({ id: 'e-1', amount: 50 }),
      getExpenses: jest.fn().mockResolvedValue({ data: [], meta: {} }),
    };

    const mockIncomeService = {
      createIncome: jest.fn().mockResolvedValue({ id: 'i-1', amount: 500 }),
      getIncomes: jest.fn().mockResolvedValue({ data: [], meta: {} }),
    };

    const mockSavingsGoalService = {
      createGoal: jest.fn().mockResolvedValue({ id: 'g-1' }),
    };

    const mockMonthlySummaryService = {
      getMonthlySummary: jest.fn().mockResolvedValue({ totalIncome: 500, totalExpenses: 50 }),
    };

    const mockExpenseCategoryService = {
      getCategories: jest.fn().mockResolvedValue([]),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [
        BudgetController,
        ExpenseController,
        IncomeController,
        SavingsGoalController,
        MonthlySummaryController,
        ExpenseCategoryController,
      ],
      providers: [
        { provide: BudgetService, useValue: mockBudgetService },
        { provide: ExpenseService, useValue: mockExpenseService },
        { provide: IncomeService, useValue: mockIncomeService },
        { provide: SavingsGoalService, useValue: mockSavingsGoalService },
        { provide: MonthlySummaryService, useValue: mockMonthlySummaryService },
        { provide: ExpenseCategoryService, useValue: mockExpenseCategoryService },
      ],
    }).compile();

    budgetController = module.get<BudgetController>(BudgetController);
    expenseController = module.get<ExpenseController>(ExpenseController);
    incomeController = module.get<IncomeController>(IncomeController);
  });

  it('should create a budget', async () => {
    const res = await budgetController.createBudget(mockUserId, {
      month: 9,
      year: 2026,
      plannedAmount: 1000,
    });
    expect(res.id).toBe('b-1');
  });

  it('should create an expense', async () => {
    const res = await expenseController.createExpense(mockUserId, {
      categoryId: 'cat-1',
      title: 'Coffee',
      amount: 5,
      expenseDate: '2026-09-15T09:00:00Z',
    });
    expect(res.id).toBe('e-1');
  });

  it('should create income', async () => {
    const res = await incomeController.createIncome(mockUserId, {
      source: 'Stipend',
      amount: 500,
      receivedDate: '2026-09-01T00:00:00Z',
    });
    expect(res.id).toBe('i-1');
  });
});
