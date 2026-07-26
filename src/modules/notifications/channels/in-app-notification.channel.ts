import { Injectable, Logger } from '@nestjs/common';
import { INotificationChannel, INotificationPayload, INotificationDeliveryResult } from './notification-channel.interface';
import { NotificationChannel } from '../constants/notification-enums.constants';

@Injectable()
export class InAppNotificationChannel implements INotificationChannel {
  readonly channelType = NotificationChannel.IN_APP;
  private readonly logger = new Logger(InAppNotificationChannel.name);

  async send(payload: INotificationPayload): Promise<INotificationDeliveryResult> {
    this.logger.log(`[In-App Channel] Sent notification to user ${payload.userId}: "${payload.title}"`);
    return {
      success: true,
      channel: NotificationChannel.IN_APP,
      messageId: `in_app_${payload.userId}_${Date.now()}`,
    };
  }
}
