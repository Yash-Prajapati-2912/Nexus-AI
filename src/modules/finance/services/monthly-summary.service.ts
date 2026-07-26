import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MonthlySummaryRepository } from '../repositories/monthly-summary.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { IncomeRepository } from '../repositories/income.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { MonthlySummaryQueryDto } from '../dto/monthly-summary-query.dto';
import { MonthlySummaryResponseDto } from '../dto/monthly-summary-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { MonthlySummaryUpdatedEvent } from '../events/monthly-summary-updated.event';

@Injectable()
export class MonthlySummaryService {
  private readonly logger = new Logger(MonthlySummaryService.name);

  constructor(
    private readonly summaryRepository: MonthlySummaryRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly incomeRepository: IncomeRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getMonthlySummary(
    userId: string,
    queryDto: MonthlySummaryQueryDto,
  ): Promise<MonthlySummaryResponseDto> {
    const now = new Date();
    const month = queryDto.month || now.getUTCMonth() + 1;
    const year = queryDto.year || now.getUTCFullYear();

    let summary = await this.summaryRepository.findByUserAndPeriod(userId, month, year);

    if (!summary) {
      summary = await this.recalculateSummary(userId, month, year);
    }

    return FinanceMapper.toMonthlySummaryDto(summary);
  }

  async recalculateSummary(
    userId: string,
    month: number,
    year: number,
  ) {
    this.logger.log(`Recalculating monthly summary for user ${userId} (${month}/${year})`);

    const totalIncome = await this.incomeRepository.calculateTotalIncomeForPeriod(
      userId,
      month,
      year,
    );

    const totalExpenses = await this.expenseRepository.calculateTotalSpentForPeriod(
      userId,
      month,
      year,
    );

    const budget = await this.budgetRepository.findByUserAndPeriod(userId, month, year);
    const plannedBudget = budget ? Number(budget.plannedAmount) : 0;
    const remainingBudget = plannedBudget > 0 ? plannedBudget - totalExpenses : 0;

    const savings = totalIncome - totalExpenses;

    const daysInMonth = new Date(year, month, 0).getDate();
    const averageDailySpending = parseFloat((totalExpenses / daysInMonth).toFixed(2));

    const topCategories = await this.expenseRepository.getCategoryBreakdownForPeriod(
      userId,
      month,
      year,
    );

    const budgetUtilisationPercentage =
      plannedBudget > 0
        ? parseFloat(((totalExpenses / plannedBudget) * 100).toFixed(2))
        : 0;

    let summary = await this.summaryRepository.findByUserAndPeriod(userId, month, year);

    if (!summary) {
      summary = this.summaryRepository.create(
        {
          userId,
          month,
          year,
          totalIncome,
          totalExpenses,
          remainingBudget,
          savings,
          averageDailySpending,
          topCategories,
          budgetUtilisationPercentage,
        },
        userId,
      );
    } else {
      summary.totalIncome = totalIncome;
      summary.totalExpenses = totalExpenses;
      summary.remainingBudget = remainingBudget;
      summary.savings = savings;
      summary.averageDailySpending = averageDailySpending;
      summary.topCategories = topCategories;
      summary.budgetUtilisationPercentage = budgetUtilisationPercentage;
    }

    const saved = await this.summaryRepository.save(summary, userId);

    this.eventEmitter.emit(
      FINANCE_EVENTS.MONTHLY_SUMMARY_UPDATED,
      new MonthlySummaryUpdatedEvent(
        saved.id,
        userId,
        saved.month,
        saved.year,
        saved.totalIncome,
        saved.totalExpenses,
        saved.remainingBudget,
      ),
    );

    return saved;
  }
}
