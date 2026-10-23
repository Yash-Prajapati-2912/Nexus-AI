import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';

@Injectable()
export class FinanceAnalyticsListener {
  private readonly logger = new Logger(FinanceAnalyticsListener.name);

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  handleExpenseAdded(event: any): Promise<void> {
    this.logger.debug(`[ANALYTICS] Expense ingested: User ${event.userId}, Amount: $${event.amount}`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.MONTHLY_SUMMARY_UPDATED, { async: true })
  handleSummaryUpdated(event: any): Promise<void> {
    this.logger.debug(`[ANALYTICS] Monthly summary metrics updated for period ${event.month}/${event.year}`);
    return Promise.resolve();
  }
}
