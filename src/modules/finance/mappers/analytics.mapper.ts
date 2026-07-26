import { FinancialAnalytics } from '../entities/financial-analytics.entity';
import { FinancialMetric } from '../entities/financial-metric.entity';
import { FinancialTrend } from '../entities/financial-trend.entity';
import { BudgetAlert } from '../entities/budget-alert.entity';
import { CashFlowSummary } from '../entities/cash-flow-summary.entity';
import { FinancialReport } from '../entities/financial-report.entity';

import {
  FinancialAnalyticsResponseDto,
  FinancialMetricDto,
} from '../dto/analytics-response.dto';
import { CashFlowResponseDto } from '../dto/cash-flow-response.dto';
import { TrendPointDto, TrendResponseDto } from '../dto/trend-response.dto';
import { BudgetAlertResponseDto } from '../dto/budget-alert-response.dto';
import { FinancialReportResponseDto } from '../dto/report-response.dto';
import { CategoryBreakdownDto } from '../dto/monthly-summary-response.dto';

export class AnalyticsMapper {
  static toMetricDto(entity: FinancialMetric): FinancialMetricDto {
    return {
      metricKey: entity.metricKey,
      metricValue: entity.metricValue,
      calculatedAt: entity.calculatedAt,
    };
  }

  static toAlertDto(entity: BudgetAlert): BudgetAlertResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      budgetId: entity.budgetId,
      savingsGoalId: entity.savingsGoalId,
      alertType: entity.alertType,
      thresholdPercentage: Number(entity.thresholdPercentage),
      message: entity.message,
      isRead: entity.isRead,
      triggeredAt: entity.triggeredAt,
    };
  }

  static toTrendPointDto(entity: FinancialTrend): TrendPointDto {
    return {
      periodLabel: entity.periodLabel,
      incomeGrowthPercentage: Number(entity.incomeGrowthPercentage),
      expenseGrowthPercentage: Number(entity.expenseGrowthPercentage),
      savingsGrowthPercentage: Number(entity.savingsGrowthPercentage),
      budgetConsumptionRate: Number(entity.budgetConsumptionRate),
      netCashFlow: Number(entity.netCashFlow),
    };
  }

  static toReportDto(entity: FinancialReport): FinancialReportResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      reportType: entity.reportType,
      title: entity.title,
      startDate: entity.startDate,
      endDate: entity.endDate,
      summaryData: entity.summaryData,
      format: entity.format,
      downloadUrl: entity.downloadUrl,
      createdAt: entity.createdAt,
    };
  }
}
