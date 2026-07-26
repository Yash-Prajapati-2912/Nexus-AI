import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { FinancialReportRepository } from '../../repositories/financial-report.repository';
import { FinanceDataAggregator } from '../../analytics/aggregators/finance-data.aggregator';
import { SpendingCalculator } from '../../analytics/calculators/spending.calculator';
import { CashFlowCalculator } from '../../analytics/calculators/cash-flow.calculator';
import { ReportQueryDto } from '../../dto/report-query.dto';
import { FinancialReportResponseDto } from '../../dto/report-response.dto';
import { AnalyticsMapper } from '../../mappers/analytics.mapper';
import { ExportFormat, ReportType } from '../../constants/analytics-enums.constants';
import { ANALYTICS_EVENTS } from '../../constants/analytics-events.constants';
import { FinancialReportGeneratedEvent } from '../../events/financial-report-generated.event';

@Injectable()
export class ReportGeneratorService {
  private readonly logger = new Logger(ReportGeneratorService.name);

  constructor(
    private readonly reportRepository: FinancialReportRepository,
    private readonly aggregator: FinanceDataAggregator,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async generateReport(
    userId: string,
    queryDto: ReportQueryDto,
  ): Promise<FinancialReportResponseDto> {
    const { startDate, endDate, title } = this.resolveReportBounds(queryDto);

    const data = await this.aggregator.aggregatePeriodData(userId, startDate, endDate);
    const totalDays = Math.max(1, Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24)));

    const spendingStats = SpendingCalculator.calculateStats(data.expenses, totalDays);
    const cashFlowStats = CashFlowCalculator.calculateCashFlow(data.incomes, data.expenses, startDate, endDate);

    const summaryData = {
      period: {
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        days: totalDays,
      },
      spending: spendingStats,
      cashFlow: {
        totalInflow: cashFlowStats.totalInflow,
        totalOutflow: cashFlowStats.totalOutflow,
        netCashFlow: cashFlowStats.netCashFlow,
        dailyAverageInflow: cashFlowStats.dailyAverageInflow,
        dailyAverageOutflow: cashFlowStats.dailyAverageOutflow,
      },
      budget: data.budget
        ? {
            plannedAmount: Number(data.budget.plannedAmount),
            spentAmount: Number(data.budget.spentAmount),
            remainingAmount: Number(data.budget.remainingAmount),
            status: data.budget.status,
          }
        : null,
      savingsGoalsCount: data.savingsGoals.length,
    };

    const report = this.reportRepository.create(
      {
        userId,
        reportType: queryDto.reportType || ReportType.MONTHLY,
        title,
        startDate,
        endDate,
        summaryData,
        format: queryDto.format || ExportFormat.JSON,
        downloadUrl: null,
      },
      userId,
    );

    const saved = await this.reportRepository.save(report, userId);

    this.eventEmitter.emit(
      ANALYTICS_EVENTS.REPORT_GENERATED,
      new FinancialReportGeneratedEvent(saved.id, userId, saved.reportType, saved.format),
    );

    return AnalyticsMapper.toReportDto(saved);
  }

  async getUserReports(
    userId: string,
    reportType?: ReportType,
  ): Promise<FinancialReportResponseDto[]> {
    const reports = await this.reportRepository.findUserReports(userId, reportType);
    return reports.map(AnalyticsMapper.toReportDto);
  }

  private resolveReportBounds(queryDto: ReportQueryDto): { startDate: Date; endDate: Date; title: string } {
    const now = new Date();
    const type = queryDto.reportType || ReportType.MONTHLY;

    if (queryDto.startDate && queryDto.endDate) {
      return {
        startDate: new Date(queryDto.startDate),
        endDate: new Date(queryDto.endDate),
        title: `Custom Financial Report (${queryDto.startDate} to ${queryDto.endDate})`,
      };
    }

    switch (type) {
      case ReportType.DAILY: {
        const start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
        const end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Daily Financial Report - ${start.toISOString().split('T')[0]}` };
      }
      case ReportType.WEEKLY: {
        const start = new Date(now.setDate(now.getDate() - now.getDay()));
        start.setHours(0, 0, 0, 0);
        const end = new Date(start);
        end.setDate(end.getDate() + 6);
        end.setHours(23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Weekly Financial Report - Week of ${start.toISOString().split('T')[0]}` };
      }
      case ReportType.QUARTERLY: {
        const currentQuarter = Math.floor(now.getMonth() / 3);
        const start = new Date(now.getFullYear(), currentQuarter * 3, 1, 0, 0, 0);
        const end = new Date(now.getFullYear(), (currentQuarter + 1) * 3, 0, 23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Q${currentQuarter + 1} ${now.getFullYear()} Quarterly Report` };
      }
      case ReportType.YEARLY: {
        const start = new Date(now.getFullYear(), 0, 1, 0, 0, 0);
        const end = new Date(now.getFullYear(), 11, 31, 23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Annual Financial Report ${now.getFullYear()}` };
      }
      case ReportType.MONTHLY:
      default: {
        const start = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0);
        const end = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Monthly Financial Report - ${now.toLocaleString('default', { month: 'long' })} ${now.getFullYear()}` };
      }
    }
  }
}
