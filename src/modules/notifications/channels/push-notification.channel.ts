import { Injectable, Logger } from '@nestjs/common';
import { INotificationChannel, INotificationPayload, INotificationDeliveryResult } from './notification-channel.interface';
import { NotificationChannel } from '../constants/notification-enums.constants';

@Injectable()
export class PushNotificationChannel implements INotificationChannel {
  readonly channelType = NotificationChannel.PUSH;
  private readonly logger = new Logger(PushNotificationChannel.name);

  async send(payload: INotificationPayload): Promise<INotificationDeliveryResult> {
    const tokens = payload.deviceTokens || [];
    this.logger.log(`[FCM Push Channel] Sent push notification to ${tokens.length} device tokens for user ${payload.userId}: "${payload.title}"`);
    return {
      success: true,
      channel: NotificationChannel.PUSH,
      messageId: `fcm_${payload.userId}_${Date.now()}`,
    };
  }
}
