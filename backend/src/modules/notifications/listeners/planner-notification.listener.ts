import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { NotificationCategory } from '../constants/notification-enums.constants';

@Injectable()
export class PlannerNotificationListener {
  private readonly logger = new Logger(PlannerNotificationListener.name);

  constructor(private readonly notificationService: NotificationService) {}

  @OnEvent('planner.task_created', { async: true })
  async handleTaskCreated(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`PlannerNotificationListener: Handling task_created for user ${event.userId}`);
      await this.notificationService.sendNotification(
        event.userId,
        NotificationCategory.PLANNER_REMINDER,
        'New Task Created',
        `Task "${event.title || 'New Task'}" was created in your planner.`,
        { deepLink: '/planner' },
      );
    }
  }
}
