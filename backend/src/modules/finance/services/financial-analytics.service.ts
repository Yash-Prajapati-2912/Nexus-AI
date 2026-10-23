import { Injectable, Logger } from '@nestjs/common';
import { FinanceDataAggregator } from '../analytics/aggregators/finance-data.aggregator';
import { SpendingCalculator } from '../analytics/calculators/spending.calculator';
import { MetricsCalculator } from '../analytics/calculators/metrics.calculator';
import { ExpenseRepository } from '../repositories/expense.repository';
import { FinancialMetricRepository } from '../repositories/financial-metric.repository';
import { AnalyticsQueryDto } from '../dto/analytics-query.dto';
import { FinancialAnalyticsResponseDto } from '../dto/analytics-response.dto';
import { AnalyticsDatePreset, MetricKey } from '../constants/analytics-enums.constants';
import { FinanceDateUtils } from '../utils/finance-date.utils';

@Injectable()
export class FinancialAnalyticsService {
  private readonly logger = new Logger(FinancialAnalyticsService.name);

  constructor(
    private readonly aggregator: FinanceDataAggregator,
    private readonly expenseRepository: ExpenseRepository,
    private readonly metricRepository: FinancialMetricRepository,
  ) {}

  async getAnalytics(
    userId: string,
    queryDto: AnalyticsQueryDto,
  ): Promise<FinancialAnalyticsResponseDto> {
    const { startDate, endDate } = this.resolveDateBounds(queryDto);

    const data = await this.aggregator.aggregatePeriodData(userId, startDate, endDate);
    const daysInPeriod = Math.max(
      1,
      Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24)),
    );

    const spendingStats = SpendingCalculator.calculateStats(data.expenses, daysInPeriod);
    const totalIncome = data.incomes.reduce((sum, i) => sum + Number(i.amount), 0);
    const netBalance = parseFloat((totalIncome - spendingStats.totalExpenses).toFixed(2));
    const savingsRate =
      totalIncome > 0
        ? parseFloat((Math.max(0, netBalance / totalIncome) * 100).toFixed(2))
        : 0;

    const plannedBudget = data.budget ? Number(data.budget.plannedAmount) : 0;
    const remainingBudget = data.budget ? Number(data.budget.remainingAmount) : 0;
    const budgetUtilisation =
      plannedBudget > 0
        ? parseFloat(((spendingStats.totalExpenses / plannedBudget) * 100).toFixed(2))
        : 0;

    const computedMetrics = MetricsCalculator.calculateMetrics(
      data.expenses,
      data.budget,
      data.savingsGoals,
      daysInPeriod,
    );

    // Save metric key values
    await Promise.all([
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.BUDGET_ACCURACY,
        `${computedMetrics.budgetAccuracy}%`,
      ),
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.EXPENSE_FREQUENCY,
        `${computedMetrics.expenseFrequency} req/day`,
      ),
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.SAVINGS_PROGRESS,
        `${computedMetrics.savingsProgress}%`,
      ),
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.AVG_TRANSACTION_VALUE,
        `$${computedMetrics.avgTransactionValue}`,
      ),
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.MOST_ACTIVE_SPENDING_DAY,
        computedMetrics.mostActiveSpendingDay,
      ),
      this.metricRepository.upsertMetric(
        userId,
        MetricKey.MOST_ACTIVE_CATEGORY,
        computedMetrics.mostActiveCategory,
      ),
    ]);

    const month = startDate.getUTCMonth() + 1;
    const year = startDate.getUTCFullYear();
    const categoryDistribution = await this.expenseRepository.getCategoryBreakdownForPeriod(
      userId,
      month,
      year,
    );

    const metricsList = await this.metricRepository.findUserMetrics(userId);

    return {
      overview: {
        totalIncome: parseFloat(totalIncome.toFixed(2)),
        totalExpenses: spendingStats.totalExpenses,
        netBalance,
        savingsRate,
        avgDailySpending: spendingStats.avgDailySpending,
        medianSpending: spendingStats.medianSpending,
        highestExpense: spendingStats.highestExpense,
        lowestExpense: spendingStats.lowestExpense,
        plannedBudget,
        remainingBudget,
        budgetUtilisation,
      },
      categoryDistribution: categoryDistribution.map((c) => ({
        categoryId: c.categoryId,
        categoryName: c.categoryName,
        colour: c.colour,
        icon: c.icon,
        totalAmount: c.totalAmount,
        percentage: c.percentage,
      })),
      metrics: metricsList.map((m) => ({
        metricKey: m.metricKey,
        metricValue: m.metricValue,
        calculatedAt: m.calculatedAt,
      })),
    };
  }

  private resolveDateBounds(queryDto: AnalyticsQueryDto): { startDate: Date; endDate: Date } {
    const now = new Date();
    if (queryDto.startDate && queryDto.endDate) {
      return {
        startDate: FinanceDateUtils.parseStartDate(queryDto.startDate),
        endDate: FinanceDateUtils.parseEndDate(queryDto.endDate),
      };
    }

    const preset = queryDto.preset || AnalyticsDatePreset.THIS_MONTH;
    switch (preset) {
      case AnalyticsDatePreset.TODAY: {
        return {
          startDate: FinanceDateUtils.getStartOfDay(now),
          endDate: FinanceDateUtils.getEndOfDay(now),
        };
      }
      case AnalyticsDatePreset.YESTERDAY: {
        const yest = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
        return {
          startDate: FinanceDateUtils.getStartOfDay(yest),
          endDate: FinanceDateUtils.getEndOfDay(yest),
        };
      }
      case AnalyticsDatePreset.THIS_WEEK: {
        return {
          startDate: FinanceDateUtils.getStartOfWeek(now),
          endDate: FinanceDateUtils.getEndOfWeek(now),
        };
      }
      case AnalyticsDatePreset.LAST_WEEK: {
        const thisMonday = FinanceDateUtils.getStartOfWeek(now);
        const lastMonday = new Date(thisMonday.getFullYear(), thisMonday.getMonth(), thisMonday.getDate() - 7, 0, 0, 0, 0);
        const lastSunday = new Date(thisMonday.getFullYear(), thisMonday.getMonth(), thisMonday.getDate() - 1, 23, 59, 59, 999);
        return { startDate: lastMonday, endDate: lastSunday };
      }
      case AnalyticsDatePreset.LAST_MONTH: {
        const prevMonthDate = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        return {
          startDate: FinanceDateUtils.getStartOfMonth(prevMonthDate.getFullYear(), prevMonthDate.getMonth() + 1),
          endDate: FinanceDateUtils.getEndOfMonth(prevMonthDate.getFullYear(), prevMonthDate.getMonth() + 1),
        };
      }
      case AnalyticsDatePreset.THIS_MONTH:
      default: {
        return {
          startDate: FinanceDateUtils.getStartOfMonth(now.getFullYear(), now.getMonth() + 1),
          endDate: FinanceDateUtils.getEndOfMonth(now.getFullYear(), now.getMonth() + 1),
        };
      }
    }
  }
}
