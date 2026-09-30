import { FinanceOverviewAggregator } from '../aggregators/finance-overview.aggregator';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { IncomeRepository } from '../../finance/repositories/income.repository';
import { SavingsGoalRepository } from '../../finance/repositories/savings-goal.repository';
import { AIFinancialAnalysisRepository } from '../../finance/ai/repositories/ai-financial-analysis.repository';

describe('FinanceOverviewAggregator', () => {
  let aggregator: FinanceOverviewAggregator;
  let mockBudgetRepo: Partial<BudgetRepository>;
  let mockExpenseRepo: Partial<ExpenseRepository>;
  let mockIncomeRepo: Partial<IncomeRepository>;
  let mockSavingsGoalRepo: Partial<SavingsGoalRepository>;
  let mockAIRepo: Partial<AIFinancialAnalysisRepository>;

  const userId = 'user-test-uuid';

  beforeEach(() => {
    mockBudgetRepo = {
      findByUserAndPeriod: jest.fn().mockResolvedValue(null),
    };
    mockExpenseRepo = {
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(0),
      findFilteredExpenses: jest.fn().mockResolvedValue({ data: [], total: 0 }),
      getCategoryBreakdownForPeriod: jest.fn().mockResolvedValue([]),
      findMany: jest.fn().mockResolvedValue([]),
    };
    mockIncomeRepo = {
      calculateTotalIncomeForPeriod: jest.fn().mockResolvedValue(0),
    };
    mockSavingsGoalRepo = {
      findUserSavingsGoals: jest.fn().mockResolvedValue([]),
    };
    mockAIRepo = {
      findLatestForUser: jest.fn().mockResolvedValue(null),
    };

    aggregator = new FinanceOverviewAggregator(
      mockBudgetRepo as BudgetRepository,
      mockExpenseRepo as ExpenseRepository,
      mockIncomeRepo as IncomeRepository,
      mockSavingsGoalRepo as SavingsGoalRepository,
      mockAIRepo as AIFinancialAnalysisRepository,
    );
  });

  it('should return clean 0 / empty state when user has no finance data (no fake values)', async () => {
    const data = await aggregator.aggregate(userId);

    expect(data.monthlyBudgetPlanned).toBe(0);
    expect(data.totalSpentMonth).toBe(0);
    expect(data.remainingBudget).toBe(0);
    expect(data.todaysSpending).toBe(0);
    expect(data.savingsProgressPercentage).toBe(0);
    expect(data.totalIncome).toBe(0);
    expect(data.netBalance).toBe(0);
    expect(data.aiFinancialTip).toBeNull();
    expect(data.categoryExpenses).toEqual([]);
  });

  it('should calculate accurate canonical values for Income ₹10,000, Expenses ₹3,000', async () => {
    (mockIncomeRepo.calculateTotalIncomeForPeriod as jest.Mock).mockResolvedValue(10000);
    (mockExpenseRepo.calculateTotalSpentForPeriod as jest.Mock).mockResolvedValue(3000);
    (mockBudgetRepo.findByUserAndPeriod as jest.Mock).mockResolvedValue({
      plannedAmount: 5000,
      spentAmount: 3000,
      remainingAmount: 2000,
    });
    (mockExpenseRepo.findFilteredExpenses as jest.Mock).mockResolvedValue({
      data: [{ amount: 450 }],
      total: 1,
    });
    (mockSavingsGoalRepo.findUserSavingsGoals as jest.Mock).mockResolvedValue([
      { targetAmount: 20000, currentAmount: 10000 },
    ]);
    (mockExpenseRepo.getCategoryBreakdownForPeriod as jest.Mock).mockResolvedValue([
      { categoryName: 'Food', totalAmount: 2000 },
      { categoryName: 'Transport', totalAmount: 1000 },
    ]);

    const data = await aggregator.aggregate(userId);

    expect(data.totalIncome).toBe(10000);
    expect(data.totalSpentMonth).toBe(3000);
    expect(data.netBalance).toBe(7000);
    expect(data.monthlyBudgetPlanned).toBe(5000);
    expect(data.remainingBudget).toBe(2000);
    expect(data.todaysSpending).toBe(450);
    expect(data.savingsProgressPercentage).toBe(50);
    expect(data.categoryExpenses).toEqual([
      { label: 'Food', value: 2000 },
      { label: 'Transport', value: 1000 },
    ]);
  });

  it('should update correctly when an additional ₹1,000 expense is logged', async () => {
    (mockIncomeRepo.calculateTotalIncomeForPeriod as jest.Mock).mockResolvedValue(10000);
    (mockExpenseRepo.calculateTotalSpentForPeriod as jest.Mock).mockResolvedValue(4000);
    (mockBudgetRepo.findByUserAndPeriod as jest.Mock).mockResolvedValue({
      plannedAmount: 5000,
      spentAmount: 4000,
      remainingAmount: 1000,
    });

    const data = await aggregator.aggregate(userId);

    expect(data.totalIncome).toBe(10000);
    expect(data.totalSpentMonth).toBe(4000);
    expect(data.netBalance).toBe(6000);
    expect(data.remainingBudget).toBe(1000);
  });
});
