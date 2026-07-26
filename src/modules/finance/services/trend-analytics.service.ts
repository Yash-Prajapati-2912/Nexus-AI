import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { FinancialTrendRepository } from '../repositories/financial-trend.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { IncomeRepository } from '../repositories/income.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { TrendCalculator } from '../analytics/calculators/trend.calculator';
import { TrendResponseDto } from '../dto/trend-response.dto';
import { AnalyticsMapper } from '../mappers/analytics.mapper';
import { ANALYTICS_EVENTS } from '../constants/analytics-events.constants';
import { TrendCalculatedEvent } from '../events/trend-calculated.event';

@Injectable()
export class TrendAnalyticsService {
  private readonly logger = new Logger(TrendAnalyticsService.name);

  constructor(
    private readonly trendRepository: FinancialTrendRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getTrends(
    userId: string,
    periodType: string = 'MONTHLY',
    limit: number = 6,
  ): Promise<TrendResponseDto> {
    const now = new Date();
    const currentMonth = now.getUTCMonth() + 1;
    const currentYear = now.getUTCFullYear();

    // Compute trends for past `limit` months
    for (let i = 0; i < limit; i++) {
      const d = new Date(Date.UTC(currentYear, currentMonth - 1 - i, 1));
      const m = d.getUTCMonth() + 1;
      const y = d.getUTCFullYear();

      const prevD = new Date(Date.UTC(y, m - 2, 1));
      const prevM = prevD.getUTCMonth() + 1;
      const prevY = prevD.getUTCFullYear();

      const label = `${y}-${m.toString().padStart(2, '0')}`;

      const [currExp, prevExp, currInc, prevInc, budget] = await Promise.all([
        this.expenseRepository.calculateTotalSpentForPeriod(userId, m, y),
        this.expenseRepository.calculateTotalSpentForPeriod(userId, prevM, prevY),
        this.incomeRepository.calculateTotalIncomeForPeriod(userId, m, y),
        this.incomeRepository.calculateTotalIncomeForPeriod(userId, prevM, prevY),
        this.budgetRepository.findByUserAndPeriod(userId, m, y),
      ]);

      const currSav = currInc - currExp;
      const prevSav = prevInc - prevExp;

      const computed = TrendCalculator.calculateTrends({
        currentIncome: currInc,
        previousIncome: prevInc,
        currentExpense: currExp,
        previousExpense: prevExp,
        currentSavings: currSav,
        previousSavings: prevSav,
        plannedBudget: budget ? Number(budget.plannedAmount) : 0,
      });

      let trend = await this.trendRepository.findOne({
        where: { userId, periodType, periodLabel: label },
      });

      if (!trend) {
        trend = this.trendRepository.create(
          {
            userId,
            periodType,
            periodLabel: label,
            incomeGrowthPercentage: computed.incomeGrowthPercentage,
            expenseGrowthPercentage: computed.expenseGrowthPercentage,
            savingsGrowthPercentage: computed.savingsGrowthPercentage,
            budgetConsumptionRate: computed.budgetConsumptionRate,
            netCashFlow: computed.netCashFlow,
          },
          userId,
        );
      } else {
        trend.incomeGrowthPercentage = computed.incomeGrowthPercentage;
        trend.expenseGrowthPercentage = computed.expenseGrowthPercentage;
        trend.savingsGrowthPercentage = computed.savingsGrowthPercentage;
        trend.budgetConsumptionRate = computed.budgetConsumptionRate;
        trend.netCashFlow = computed.netCashFlow;
      }

      await this.trendRepository.save(trend, userId);

      if (i === 0) {
        this.eventEmitter.emit(
          ANALYTICS_EVENTS.TREND_CALCULATED,
          new TrendCalculatedEvent(
            userId,
            label,
            computed.expenseGrowthPercentage,
            computed.savingsGrowthPercentage,
          ),
        );
      }
    }

    const trends = await this.trendRepository.findUserTrends(userId, periodType, limit);
    return {
      periodType,
      trends: trends.map(AnalyticsMapper.toTrendPointDto),
    };
  }
}
