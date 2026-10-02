import { Injectable, Logger, Optional } from '@nestjs/common';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { IncomeRepository } from '../../finance/repositories/income.repository';
import { SavingsGoalRepository } from '../../finance/repositories/savings-goal.repository';
import { AIFinancialAnalysisRepository } from '../../finance/ai/repositories/ai-financial-analysis.repository';
import { DateRangePreset, SavingsStatus, BudgetStatus } from '../../finance/constants/finance-enums.constants';
import { IFinanceOverviewData } from '../interfaces/aggregated-dashboard-data.interface';

@Injectable()
export class FinanceOverviewAggregator {
  private readonly logger = new Logger(FinanceOverviewAggregator.name);

  constructor(
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly savingsGoalRepository: SavingsGoalRepository,
    @Optional() private readonly aiAnalysisRepository?: AIFinancialAnalysisRepository,
  ) {}

  async aggregate(userId: string): Promise<IFinanceOverviewData> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const [budget, monthExpenses, monthIncome, savingsGoals, todayExpensesRes, categoryBreakdown, latestAI, recentExpenses, recentIncomes] =
      await Promise.all([
        this.budgetRepository.findByUserAndPeriod(userId, month, year).catch(() => null),
        this.expenseRepository.calculateTotalSpentForPeriod(userId, month, year).catch(() => 0),
        this.incomeRepository.calculateTotalIncomeForPeriod(userId, month, year).catch(() => 0),
        this.savingsGoalRepository.findUserSavingsGoals(userId).catch(() => []),
        this.expenseRepository
          .findFilteredExpenses(userId, { dateRangePreset: DateRangePreset.TODAY, limit: 500 })
          .catch(() => ({ data: [], total: 0 })),
        this.expenseRepository.getCategoryBreakdownForPeriod(userId, month, year).catch(() => []),
        this.aiAnalysisRepository
          ? this.aiAnalysisRepository.findLatestForUser(userId).catch(() => null)
          : Promise.resolve(null),
        this.expenseRepository
          .findMany({
            where: { userId },
            relations: ['category'],
            order: { expenseDate: 'DESC' },
            take: 5,
          })
          .catch(() => []),
        typeof this.incomeRepository.findFilteredIncomes === 'function'
          ? this.incomeRepository
              .findFilteredIncomes(userId, { limit: 5 })
              .catch(() => ({ data: [], total: 0 }))
          : Promise.resolve({ data: [], total: 0 }),
      ]);

    // Active budget resolution (fallback to user active budget if current month budget not explicitly keyed)
    let activeBudget = budget;
    if (!activeBudget) {
      if (typeof this.budgetRepository.findActiveByUserAndPeriod === 'function') {
        activeBudget = await this.budgetRepository.findActiveByUserAndPeriod(userId, month, year).catch(() => null);
      }
      if (!activeBudget && typeof this.budgetRepository.findUserBudgets === 'function') {
        const userBudgets = await this.budgetRepository.findUserBudgets(userId).catch(() => []);
        activeBudget = userBudgets.find((b) => b.status === BudgetStatus.ACTIVE) || null;
      }
    }

    let spent = monthExpenses;
    if (spent === 0 && recentExpenses && recentExpenses.length > 0 && typeof this.expenseRepository.findFilteredExpenses === 'function') {
      const allExpenses = await this.expenseRepository.findFilteredExpenses(userId, { limit: 1000 }).catch(() => ({ data: [], total: 0 }));
      if (allExpenses.data && allExpenses.data.length > 0) {
        spent = allExpenses.data.reduce((sum, e) => sum + Number(e.amount), 0);
      }
    }

    let totalIncome = monthIncome;
    if (totalIncome === 0 && typeof this.incomeRepository.findFilteredIncomes === 'function') {
      const allIncomes = await this.incomeRepository.findFilteredIncomes(userId, { limit: 1000 }).catch(() => ({ data: [], total: 0 }));
      if (allIncomes.data && allIncomes.data.length > 0) {
        totalIncome = allIncomes.data.reduce((sum, i) => sum + Number(i.amount), 0);
      }
    }

    const planned = activeBudget ? Number(activeBudget.plannedAmount) : 0;
    const remaining = activeBudget ? Number(activeBudget.remainingAmount) : Math.max(0, planned - spent);
    const todaysSpending = (todayExpensesRes?.data || []).reduce(
      (sum, exp) => sum + Number(exp.amount),
      0,
    );
    const netBalance = parseFloat((totalIncome - spent).toFixed(2));

    // Dynamic savings progress calculation from real user savings goals
    let savingsProgressPercentage = 0;
    let activeGoalTitle: string | null = null;
    let activeGoalTarget = 0;
    let activeGoalCurrent = 0;

    if (savingsGoals && savingsGoals.length > 0) {
      const totalTarget = savingsGoals.reduce((sum, g) => sum + Number(g.targetAmount), 0);
      const totalCurrent = savingsGoals.reduce((sum, g) => sum + Number(g.currentAmount), 0);
      savingsProgressPercentage = totalTarget > 0
        ? parseFloat(Math.min(100, (totalCurrent / totalTarget) * 100).toFixed(2))
        : 0;

      const active = savingsGoals.find((g) => g.status === SavingsStatus.IN_PROGRESS) || savingsGoals[0];
      if (active) {
        activeGoalTitle = active.title;
        activeGoalTarget = Number(active.targetAmount);
        activeGoalCurrent = Number(active.currentAmount);
      }
    }

    // Dynamic financial health score based on real metrics
    let financialHealthScore = 100;
    if (planned > 0) {
      if (spent > planned) {
        const overRatio = (spent - planned) / planned;
        financialHealthScore = Math.max(20, Math.round(70 - overRatio * 50));
      } else {
        const utilisation = spent / planned;
        financialHealthScore = Math.max(60, Math.round(100 - utilisation * 25));
      }
    } else if (totalIncome > 0) {
      const savingsRate = Math.max(0, (totalIncome - spent) / totalIncome);
      financialHealthScore = Math.min(100, Math.max(50, Math.round(50 + savingsRate * 50)));
    } else if (spent > 0) {
      financialHealthScore = 75;
    }

    // Real AI insight: genuine AI analysis or prioritized real-data intelligence
    const hasFinanceData = totalIncome > 0 || spent > 0 || planned > 0 || (savingsGoals && savingsGoals.length > 0);
    let aiFinancialTip: string | null = null;

    if (!hasFinanceData) {
      aiFinancialTip = null; // empty state handled cleanly by UI
    } else if (latestAI && latestAI.summary && latestAI.summary.trim().length > 0) {
      aiFinancialTip = latestAI.summary.trim();
    } else {
      // Prioritized real-data synthesis:
      // Priority 1: Important budget condition
      if (planned > 0) {
        const usage = Math.round((spent / planned) * 100);
        if (spent > planned) {
          aiFinancialTip = `You have exceeded your monthly budget of ₹${planned.toFixed(0)} by ₹${(spent - planned).toFixed(0)}. Pace remaining expenses to curb deficits.`;
        } else if (usage >= 85) {
          aiFinancialTip = `You have utilized ${usage}% of your monthly budget (₹${spent.toFixed(0)} of ₹${planned.toFixed(0)}), leaving ₹${remaining.toFixed(0)} for remaining days.`;
        } else if (remaining > 0) {
          aiFinancialTip = `You have ₹${remaining.toFixed(0)} remaining in your monthly budget. Your spending pace is on track at ${usage}% utilization.`;
        }
      }

      // Priority 2: Major spending category
      if (!aiFinancialTip && categoryBreakdown && categoryBreakdown.length > 0) {
        const top = categoryBreakdown[0];
        if (top.totalAmount > 0 && categoryBreakdown.length > 1) {
          aiFinancialTip = `Your ${top.categoryName} expenses (₹${top.totalAmount.toFixed(0)}) are currently your largest spending category (${top.percentage}% of total expenses).`;
        } else if (top.totalAmount > 0) {
          aiFinancialTip = `Your top expense category this month is ${top.categoryName} at ₹${top.totalAmount.toFixed(0)}.`;
        }
      }

      // Priority 3: Savings goal progress
      if (!aiFinancialTip && activeGoalTitle && activeGoalTarget > 0) {
        aiFinancialTip = `You're currently saving ₹${activeGoalCurrent.toFixed(0)} toward your active goal "${activeGoalTitle}" (${savingsProgressPercentage}% of ₹${activeGoalTarget.toFixed(0)}).`;
      }

      // Priority 4 & 5: Net cash flow & general observation
      if (!aiFinancialTip) {
        if (totalIncome > 0 && spent > 0) {
          if (netBalance >= 0) {
            aiFinancialTip = `Your net cash flow is positive with a surplus of ₹${netBalance.toFixed(0)} and an estimated savings rate of ${Math.round((netBalance / totalIncome) * 100)}%.`;
          } else {
            aiFinancialTip = `Your monthly spending exceeds current income by ₹${Math.abs(netBalance).toFixed(0)}. Review discretionary expenses to maintain balance.`;
          }
        } else if (totalIncome > 0) {
          aiFinancialTip = `You have recorded ₹${totalIncome.toFixed(0)} in income this month. Set a monthly budget to plan your savings.`;
        } else if (spent > 0) {
          aiFinancialTip = `You have recorded ₹${spent.toFixed(0)} in monthly spending. Log your income to track your overall net balance.`;
        }
      }
    }

    let resolvedCategoryExpenses = (categoryBreakdown || []).map((c) => ({
      label: c.categoryName,
      value: c.totalAmount,
    }));

    if (resolvedCategoryExpenses.length === 0 && spent > 0 && recentExpenses && recentExpenses.length > 0) {
      const catMap = new Map<string, number>();
      for (const e of recentExpenses) {
        const name = e.category?.name || 'General';
        catMap.set(name, (catMap.get(name) || 0) + Number(e.amount));
      }
      resolvedCategoryExpenses = Array.from(catMap.entries()).map(([label, value]) => ({
        label,
        value,
      }));
    }

    const expenseTx = (recentExpenses || []).map((exp) => ({
      id: exp.id,
      title: exp.title,
      amount: Number(exp.amount),
      categoryName: exp.category?.name || 'General',
      categoryColour: exp.category?.colour || '#6366F1',
      date: exp.expenseDate instanceof Date ? exp.expenseDate.toISOString() : String(exp.expenseDate),
      isExpense: true,
    }));

    const incomeTx = ((recentIncomes as any)?.data || []).map((inc: any) => ({
      id: inc.id,
      title: inc.title,
      amount: Number(inc.amount),
      categoryName: inc.source || 'Income',
      categoryColour: '#10B981',
      date: inc.receivedDate instanceof Date ? inc.receivedDate.toISOString() : String(inc.receivedDate),
      isExpense: false,
    }));

    const recentTransactions = [...expenseTx, ...incomeTx].sort(
      (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime(),
    ).slice(0, 5);

    return {
      monthlyBudgetPlanned: planned,
      totalSpentMonth: spent,
      remainingBudget: remaining,
      todaysSpending,
      savingsProgressPercentage,
      financialHealthScore,
      totalIncome,
      netBalance,
      aiFinancialTip,
      categoryExpenses: resolvedCategoryExpenses,
      activeGoalTitle,
      activeGoalTarget,
      activeGoalCurrent,
      recentTransactions,
    };
  }
}
