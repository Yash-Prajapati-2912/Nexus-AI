import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { FinanceDataAggregator } from '../analytics/aggregators/finance-data.aggregator';
import { CashFlowCalculator } from '../analytics/calculators/cash-flow.calculator';
import { CashFlowSummaryRepository } from '../repositories/cash-flow-summary.repository';
import { CashFlowQueryDto } from '../dto/cash-flow-query.dto';
import { CashFlowResponseDto } from '../dto/cash-flow-response.dto';
import { AnalyticsDatePreset } from '../constants/analytics-enums.constants';
import { ANALYTICS_EVENTS } from '../constants/analytics-events.constants';
import { CashFlowUpdatedEvent } from '../events/cash-flow-updated.event';

@Injectable()
export class CashFlowService {
  private readonly logger = new Logger(CashFlowService.name);

  constructor(
    private readonly aggregator: FinanceDataAggregator,
    private readonly cashFlowRepository: CashFlowSummaryRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getCashFlow(
    userId: string,
    queryDto: CashFlowQueryDto,
  ): Promise<CashFlowResponseDto> {
    const { startDate, endDate } = this.resolveDateBounds(queryDto);

    const data = await this.aggregator.aggregatePeriodData(userId, startDate, endDate);
    const result = CashFlowCalculator.calculateCashFlow(
      data.incomes,
      data.expenses,
      startDate,
      endDate,
    );

    let summary = await this.cashFlowRepository.findLatestForUser(userId);
    if (!summary) {
      summary = this.cashFlowRepository.create(
        {
          userId,
          startDate,
          endDate,
          totalInflow: result.totalInflow,
          totalOutflow: result.totalOutflow,
          netCashFlow: result.netCashFlow,
          dailyAverageInflow: result.dailyAverageInflow,
          dailyAverageOutflow: result.dailyAverageOutflow,
          projectedEndBalance: result.projectedEndBalance,
        },
        userId,
      );
    } else {
      summary.startDate = startDate;
      summary.endDate = endDate;
      summary.totalInflow = result.totalInflow;
      summary.totalOutflow = result.totalOutflow;
      summary.netCashFlow = result.netCashFlow;
      summary.dailyAverageInflow = result.dailyAverageInflow;
      summary.dailyAverageOutflow = result.dailyAverageOutflow;
      summary.projectedEndBalance = result.projectedEndBalance;
    }

    await this.cashFlowRepository.save(summary, userId);

    this.eventEmitter.emit(
      ANALYTICS_EVENTS.CASH_FLOW_UPDATED,
      new CashFlowUpdatedEvent(userId, result.netCashFlow, result.projectedEndBalance),
    );

    return {
      startDate,
      endDate,
      totalInflow: result.totalInflow,
      totalOutflow: result.totalOutflow,
      netCashFlow: result.netCashFlow,
      dailyAverageInflow: result.dailyAverageInflow,
      dailyAverageOutflow: result.dailyAverageOutflow,
      projectedEndBalance: result.projectedEndBalance,
      dailyBreakdown: result.dailyBreakdown,
    };
  }

  private resolveDateBounds(queryDto: CashFlowQueryDto): { startDate: Date; endDate: Date } {
    const now = new Date();
    if (queryDto.startDate && queryDto.endDate) {
      return {
        startDate: new Date(queryDto.startDate),
        endDate: new Date(queryDto.endDate),
      };
    }

    const preset = queryDto.preset || AnalyticsDatePreset.THIS_MONTH;
    switch (preset) {
      case AnalyticsDatePreset.THIS_WEEK: {
        const start = new Date(now.setDate(now.getDate() - now.getDay()));
        start.setHours(0, 0, 0, 0);
        const end = new Date(start);
        end.setDate(end.getDate() + 6);
        end.setHours(23, 59, 59, 999);
        return { startDate: start, endDate: end };
      }
      case AnalyticsDatePreset.LAST_MONTH: {
        const start = new Date(now.getFullYear(), now.getMonth() - 1, 1, 0, 0, 0);
        const end = new Date(now.getFullYear(), now.getMonth(), 0, 23, 59, 59, 999);
        return { startDate: start, endDate: end };
      }
      case AnalyticsDatePreset.THIS_MONTH:
      default: {
        const start = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0);
        const end = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
        return { startDate: start, endDate: end };
      }
    }
  }
}
