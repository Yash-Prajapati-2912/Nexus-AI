import { Notification } from '../entities/notification.entity';
import { NotificationPreference } from '../entities/notification-preference.entity';
import { NotificationResponseDto } from '../dto/notification-response.dto';
import { NotificationPreferenceResponseDto } from '../dto/notification-preference-response.dto';

export class NotificationMapper {
  static toNotificationDto(entity: Notification): NotificationResponseDto {
    return {
      id: entity.id,
      category: entity.category,
      title: entity.title,
      body: entity.body,
      isRead: entity.isRead,
      readAt: entity.readAt,
      deepLink: entity.deepLink,
      createdAt: entity.createdAt,
    };
  }

  static toPreferenceDto(entity: NotificationPreference): NotificationPreferenceResponseDto {
    return {
      pushEnabled: entity.pushEnabled,
      emailEnabled: entity.emailEnabled,
      inAppEnabled: entity.inAppEnabled,
      smsEnabled: entity.smsEnabled,
      quietHoursStart: entity.quietHoursStart,
      quietHoursEnd: entity.quietHoursEnd,
      reminderFrequency: entity.reminderFrequency,
    };
  }
}
