import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { ANALYTICS_EVENTS } from '../constants/analytics-events.constants';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';

@Injectable()
export class AnalyticsCacheListener {
  private readonly logger = new Logger(AnalyticsCacheListener.name);

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  handleExpenseAdded(event: any): Promise<void> {
    this.logger.log(`Redis/BullMQ Cache invalidate: User ${event.userId} expense added`);
    return Promise.resolve();
  }

  @OnEvent(ANALYTICS_EVENTS.CASH_FLOW_UPDATED, { async: true })
  handleCashFlowUpdated(event: any): Promise<void> {
    this.logger.log(`Redis/BullMQ Cache refresh: User ${event.userId} cash flow updated`);
    return Promise.resolve();
  }
}
