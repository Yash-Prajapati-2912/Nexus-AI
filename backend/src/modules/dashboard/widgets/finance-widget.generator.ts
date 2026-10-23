import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class FinanceWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.BUDGET_SUMMARY;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    const finance = aggregatedContext.finance || {};

    return {
      widgetType: WidgetType.BUDGET_SUMMARY,
      title: 'Financial Health & Budget',
      data: {
        monthlyBudgetPlanned: finance.monthlyBudgetPlanned || 0,
        totalSpentMonth: finance.totalSpentMonth || 0,
        remainingBudget: finance.remainingBudget || 0,
        todaysSpending: finance.todaysSpending || 0,
        savingsProgressPercentage: finance.savingsProgressPercentage || 0,
        financialHealthScore: finance.financialHealthScore || 100,
        totalIncome: finance.totalIncome || 0,
        netBalance: finance.netBalance || 0,
        aiFinancialTip: finance.aiFinancialTip || null,
        activeGoalTitle: finance.activeGoalTitle || null,
        activeGoalTarget: finance.activeGoalTarget || 0,
        activeGoalCurrent: finance.activeGoalCurrent || 0,
        recentTransactions: finance.recentTransactions || [],
      },
    };
  }
}
