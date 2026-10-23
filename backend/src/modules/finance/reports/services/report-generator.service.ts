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
import { FinanceDateUtils } from '../../utils/finance-date.utils';

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
    const cashFlowStats = (queryDto.reportType === ReportType.YEARLY)
      ? CashFlowCalculator.calculateYearlyCashFlow(data.incomes, data.expenses, startDate.getFullYear())
      : CashFlowCalculator.calculateCashFlow(data.incomes, data.expenses, startDate, endDate);

    const categoryTotals: Record<string, { name: string; colour: string; amount: number }> = {};
    let totalExpenseAmount = 0;
    for (const exp of data.expenses) {
      const amt = Number(exp.amount);
      totalExpenseAmount += amt;
      const catId = exp.categoryId || (exp.category ? exp.category.id : 'general');
      const catName = exp.category?.name || 'General';
      const colour = exp.category?.colour || '#6366F1';
      if (!categoryTotals[catId]) {
        categoryTotals[catId] = { name: catName, colour, amount: 0 };
      }
      categoryTotals[catId].amount += amt;
    }

    const expenseBreakdown = Object.values(categoryTotals).map((c) => ({
      categoryName: c.name,
      amount: parseFloat(c.amount.toFixed(2)),
      percentage: totalExpenseAmount > 0 ? parseFloat(((c.amount / totalExpenseAmount) * 100).toFixed(2)) : 0,
      colorHex: c.colour,
    }));

    const incomeTotals: Record<string, { name: string; amount: number }> = {};
    let totalIncomeAmount = 0;
    for (const inc of data.incomes) {
      const amt = Number(inc.amount);
      totalIncomeAmount += amt;
      const source = inc.source || 'General';
      if (!incomeTotals[source]) {
        incomeTotals[source] = { name: source, amount: 0 };
      }
      incomeTotals[source].amount += amt;
    }

    const incomeBreakdown = Object.values(incomeTotals).map((i) => ({
      categoryName: i.name,
      amount: parseFloat(i.amount.toFixed(2)),
      percentage: totalIncomeAmount > 0 ? parseFloat(((i.amount / totalIncomeAmount) * 100).toFixed(2)) : 0,
      colorHex: '#10B981',
    }));

    const summaryData = {
      period: {
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        days: totalDays,
      },
      spending: spendingStats,
      expenseBreakdown,
      incomeBreakdown,
      cashFlow: {
        totalInflow: cashFlowStats.totalInflow,
        totalOutflow: cashFlowStats.totalOutflow,
        netCashFlow: cashFlowStats.netCashFlow,
        dailyAverageInflow: cashFlowStats.dailyAverageInflow,
        dailyAverageOutflow: cashFlowStats.dailyAverageOutflow,
        dailyBreakdown: cashFlowStats.dailyBreakdown,
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
        startDate: FinanceDateUtils.parseStartDate(queryDto.startDate),
        endDate: FinanceDateUtils.parseEndDate(queryDto.endDate),
        title: `Custom Financial Report (${queryDto.startDate} to ${queryDto.endDate})`,
      };
    }

    switch (type) {
      case ReportType.DAILY: {
        const start = FinanceDateUtils.getStartOfDay(now);
        const end = FinanceDateUtils.getEndOfDay(now);
        return { startDate: start, endDate: end, title: `Daily Financial Report - ${FinanceDateUtils.formatDate(start)}` };
      }
      case ReportType.WEEKLY: {
        const start = FinanceDateUtils.getStartOfWeek(now);
        const end = FinanceDateUtils.getEndOfWeek(now);
        return { startDate: start, endDate: end, title: `Weekly Financial Report - Week of ${FinanceDateUtils.formatDate(start)}` };
      }
      case ReportType.QUARTERLY: {
        const currentQuarter = Math.floor(now.getMonth() / 3);
        const start = new Date(now.getFullYear(), currentQuarter * 3, 1, 0, 0, 0, 0);
        const end = new Date(now.getFullYear(), (currentQuarter + 1) * 3, 0, 23, 59, 59, 999);
        return { startDate: start, endDate: end, title: `Q${currentQuarter + 1} ${now.getFullYear()} Quarterly Report` };
      }
      case ReportType.YEARLY: {
        const start = FinanceDateUtils.getStartOfYear(now.getFullYear());
        const end = FinanceDateUtils.getEndOfYear(now.getFullYear());
        return { startDate: start, endDate: end, title: `Annual Financial Report ${now.getFullYear()}` };
      }
      case ReportType.MONTHLY:
      default: {
        const start = FinanceDateUtils.getStartOfMonth(now.getFullYear(), now.getMonth() + 1);
        const end = FinanceDateUtils.getEndOfMonth(now.getFullYear(), now.getMonth() + 1);
        return { startDate: start, endDate: end, title: `Monthly Financial Report - ${now.toLocaleString('default', { month: 'long' })} ${now.getFullYear()}` };
      }
    }
  }
}
