import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';

@Injectable()
export class DashboardUpdateListener {
  private readonly logger = new Logger(DashboardUpdateListener.name);

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  handleExpenseAdded(event: any): Promise<void> {
    this.logger.debug(`[DASHBOARD REAL-TIME] Invalidate widgets for user ${event.userId}`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.INCOME_ADDED, { async: true })
  handleIncomeAdded(event: any): Promise<void> {
    this.logger.debug(`[DASHBOARD REAL-TIME] Invalidate income widget for user ${event.userId}`);
    return Promise.resolve();
  }
}
