import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';

@Injectable()
export class FinanceAuditListener {
  private readonly logger = new Logger(FinanceAuditListener.name);

  @OnEvent(FINANCE_EVENTS.BUDGET_CREATED, { async: true })
  handleBudgetCreated(event: any): Promise<void> {
    this.logger.log(`AUDIT [BUDGET_CREATED]: User ${event.userId} created budget ${event.budgetId} ($${event.plannedAmount})`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  handleExpenseAdded(event: any): Promise<void> {
    this.logger.log(`AUDIT [EXPENSE_ADDED]: User ${event.userId} added expense ${event.expenseId} ($${event.amount})`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.EXPENSE_DELETED, { async: true })
  handleExpenseDeleted(event: any): Promise<void> {
    this.logger.log(`AUDIT [EXPENSE_DELETED]: User ${event.userId} deleted expense ${event.expenseId} ($${event.amount})`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.INCOME_ADDED, { async: true })
  handleIncomeAdded(event: any): Promise<void> {
    this.logger.log(`AUDIT [INCOME_ADDED]: User ${event.userId} added income ${event.incomeId} ($${event.amount})`);
    return Promise.resolve();
  }

  @OnEvent(FINANCE_EVENTS.SAVINGS_GOAL_CREATED, { async: true })
  handleSavingsGoalCreated(event: any): Promise<void> {
    this.logger.log(`AUDIT [SAVINGS_GOAL_CREATED]: User ${event.userId} created savings goal ${event.goalId}`);
    return Promise.resolve();
  }
}
