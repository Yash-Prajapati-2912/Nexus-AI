import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { NotificationCategory } from '../constants/notification-enums.constants';

@Injectable()
export class MentorNotificationListener {
  private readonly logger = new Logger(MentorNotificationListener.name);

  constructor(private readonly notificationService: NotificationService) {}

  @OnEvent('mentor.career_roadmap_generated', { async: true })
  async handleCareerRoadmap(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`MentorNotificationListener: Handling career_roadmap for user ${event.userId}`);
      await this.notificationService.sendNotification(
        event.userId,
        NotificationCategory.CAREER_RECOMMENDATION,
        'New Career Roadmap Available',
        `Your updated career roadmap for target role "${event.targetRole || 'Software Engineer'}" is ready.`,
        { deepLink: '/mentor/roadmap' },
      );
    }
  }
}
