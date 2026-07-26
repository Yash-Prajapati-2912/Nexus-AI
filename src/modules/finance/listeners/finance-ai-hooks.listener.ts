import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';

@Injectable()
export class FinanceAIHooksListener {
  private readonly logger = new Logger(FinanceAIHooksListener.name);

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  handleExpenseAdded(event: any): Promise<void> {
    this.logger.debug(`[AI HOOK READY] Event stream hook triggered for expense: ${event.expenseId}`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.MONTHLY_SUMMARY_UPDATED, { async: true })
  handleSummaryUpdated(event: any): Promise<void> {
    this.logger.debug(`[AI HOOK READY] Event stream hook triggered for summary update: ${event.summaryId}`);
    return Promise.resolve();
  }
}
