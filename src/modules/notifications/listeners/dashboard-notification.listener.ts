import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { NotificationCategory } from '../constants/notification-enums.constants';

@Injectable()
export class DashboardNotificationListener {
  private readonly logger = new Logger(DashboardNotificationListener.name);

  constructor(private readonly notificationService: NotificationService) {}

  @OnEvent('dashboard.achievement_unlocked', { async: true })
  async handleAchievementUnlocked(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`DashboardNotificationListener: Handling achievement_unlocked for user ${event.userId}`);
      await this.notificationService.sendNotification(
        event.userId,
        NotificationCategory.ACHIEVEMENT,
        'Achievement Unlocked! 🏆',
        `Congratulations! You unlocked the "${event.title || 'Student Milestone'}" badge.`,
        { deepLink: '/dashboard/achievements' },
      );
    }
  }
}
