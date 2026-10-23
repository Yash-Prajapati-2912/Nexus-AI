import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { ExpenseAddedEvent } from '../events/expense-added.event';
import { ExpenseDeletedEvent } from '../events/expense-deleted.event';
import { IncomeAddedEvent } from '../events/income-added.event';
import { BudgetCreatedEvent } from '../events/budget-created.event';
import { MonthlySummaryService } from '../services/monthly-summary.service';

@Injectable()
export class FinanceSummaryListener {
  private readonly logger = new Logger(FinanceSummaryListener.name);

  constructor(private readonly summaryService: MonthlySummaryService) {}

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  async handleExpenseAdded(event: ExpenseAddedEvent): Promise<void> {
    this.logger.log(`Handling ExpenseAdded event for user ${event.userId}`);
    const d = new Date(event.expenseDate);
    await this.summaryService.recalculateSummary(event.userId, d.getUTCMonth() + 1, d.getUTCFullYear());
  }

  @OnEvent(FINANCE_EVENTS.EXPENSE_DELETED, { async: true })
  async handleExpenseDeleted(event: ExpenseDeletedEvent): Promise<void> {
    this.logger.log(`Handling ExpenseDeleted event for user ${event.userId}`);
    const d = new Date(event.expenseDate);
    await this.summaryService.recalculateSummary(event.userId, d.getUTCMonth() + 1, d.getUTCFullYear());
  }

  @OnEvent(FINANCE_EVENTS.INCOME_ADDED, { async: true })
  async handleIncomeAdded(event: IncomeAddedEvent): Promise<void> {
    this.logger.log(`Handling IncomeAdded event for user ${event.userId}`);
    const d = new Date(event.receivedDate);
    await this.summaryService.recalculateSummary(event.userId, d.getUTCMonth() + 1, d.getUTCFullYear());
  }

  @OnEvent(FINANCE_EVENTS.BUDGET_CREATED, { async: true })
  async handleBudgetCreated(event: BudgetCreatedEvent): Promise<void> {
    this.logger.log(`Handling BudgetCreated event for user ${event.userId}`);
    await this.summaryService.recalculateSummary(event.userId, event.month, event.year);
  }
}
