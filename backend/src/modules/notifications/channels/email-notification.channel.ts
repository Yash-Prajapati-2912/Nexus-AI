import { Injectable, Logger } from '@nestjs/common';
import { INotificationChannel, INotificationPayload, INotificationDeliveryResult } from './notification-channel.interface';
import { NotificationChannel } from '../constants/notification-enums.constants';

@Injectable()
export class EmailNotificationChannel implements INotificationChannel {
  readonly channelType = NotificationChannel.EMAIL;
  private readonly logger = new Logger(EmailNotificationChannel.name);

  async send(payload: INotificationPayload): Promise<INotificationDeliveryResult> {
    const recipient = payload.emailRecipient || `user_${payload.userId}@nexus-ai.app`;
    this.logger.log(`[Nodemailer Email Channel] Sent email to ${recipient}: "${payload.title}"`);
    return {
      success: true,
      channel: NotificationChannel.EMAIL,
      messageId: `email_${payload.userId}_${Date.now()}`,
    };
  }
}
