import { Injectable, Logger } from '@nestjs/common';
import { INotificationChannel, INotificationPayload, INotificationDeliveryResult } from './notification-channel.interface';
import { NotificationChannel } from '../constants/notification-enums.constants';

@Injectable()
export class SmsNotificationChannel implements INotificationChannel {
  readonly channelType = NotificationChannel.SMS;
  private readonly logger = new Logger(SmsNotificationChannel.name);

  async send(payload: INotificationPayload): Promise<INotificationDeliveryResult> {
    this.logger.log(`[SMS Channel Abstraction] Sent SMS to user ${payload.userId}: "${payload.title}"`);
    return {
      success: true,
      channel: NotificationChannel.SMS,
      messageId: `sms_${payload.userId}_${Date.now()}`,
    };
  }
}
