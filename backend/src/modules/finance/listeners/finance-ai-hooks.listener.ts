import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { FinanceAICacheService } from '../ai/services/finance-ai-cache.service';

@Injectable()
export class FinanceAIHooksListener {
  private readonly logger = new Logger(FinanceAIHooksListener.name);

  constructor(private readonly cacheService: FinanceAICacheService) {}

  @OnEvent(FINANCE_EVENTS.EXPENSE_ADDED, { async: true })
  async handleExpenseAdded(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on expense added`);
    }
  }

  @OnEvent(FINANCE_EVENTS.EXPENSE_DELETED, { async: true })
  async handleExpenseDeleted(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on expense deleted`);
    }
  }

  @OnEvent(FINANCE_EVENTS.INCOME_ADDED, { async: true })
  async handleIncomeAdded(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on income added`);
    }
  }

  @OnEvent(FINANCE_EVENTS.BUDGET_CREATED, { async: true })
  async handleBudgetCreated(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on budget created`);
    }
  }

  @OnEvent(FINANCE_EVENTS.SAVINGS_GOAL_CREATED, { async: true })
  async handleSavingsGoalCreated(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on savings goal created`);
    }
  }

  @OnEvent(FINANCE_EVENTS.MONTHLY_SUMMARY_UPDATED, { async: true })
  async handleSummaryUpdated(event: any): Promise<void> {
    if (event?.userId) {
      await this.cacheService.invalidateUserCache(event.userId);
      this.logger.debug(`[AI Hook] Invalidated AI cache for user ${event.userId} on summary update`);
    }
  }
}
