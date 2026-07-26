import { Injectable, Logger, Inject, forwardRef } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { ExpenseAddedEvent } from '../events/expense-added.event';
import { BudgetAlertService } from '../services/budget-alert.service';

@Injectable()
export class BudgetAlertListener {
  private readonly logger = new Logger(BudgetAlertListener.name);

  constructor(
    @Inject(forwardRef(() => BudgetAlertService))
    private readonly alertService: BudgetAlertService,
  ) {}

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  async handleExpenseAdded(event: ExpenseAddedEvent): Promise<void> {
    this.logger.log(`Evaluating budget alerts for user ${event.userId} post expense addition`);
    const date = new Date(event.expenseDate);
    await this.alertService.evaluateBudgetAlerts(
      event.userId,
      date.getUTCMonth() + 1,
      date.getUTCFullYear(),
    );
  }
}
