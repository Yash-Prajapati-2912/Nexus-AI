import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { DashboardCacheService } from '../services/dashboard-cache.service';

@Injectable()
export class FinanceEventListener {
  private readonly logger = new Logger(FinanceEventListener.name);

  constructor(private readonly cacheService: DashboardCacheService) {}

  @OnEvent('finance.expense_logged', { async: true })
  @OnEvent('finance.budget_updated', { async: true })
  async handleFinanceEvent(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`Finance event received for user ${event.userId}. Invalidating Dashboard cache.`);
      await this.cacheService.invalidateUserDashboard(event.userId);
    }
  }
}
