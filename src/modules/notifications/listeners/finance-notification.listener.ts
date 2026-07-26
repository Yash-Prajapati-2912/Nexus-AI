import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { NotificationCategory } from '../constants/notification-enums.constants';

@Injectable()
export class FinanceNotificationListener {
  private readonly logger = new Logger(FinanceNotificationListener.name);

  constructor(private readonly notificationService: NotificationService) {}

  @OnEvent('finance.budget_threshold_reached', { async: true })
  async handleBudgetThreshold(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`FinanceNotificationListener: Handling budget_threshold for user ${event.userId}`);
      await this.notificationService.sendNotification(
        event.userId,
        NotificationCategory.BUDGET_ALERT,
        'Budget Threshold Alert',
        `You have used ${event.percentage || 80}% of your monthly planned budget.`,
        { deepLink: '/finance/budgets' },
      );
    }
  }
}
