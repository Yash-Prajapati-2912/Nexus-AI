import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { INotificationChannel } from '../channels/notification-channel.interface';
import { InAppNotificationChannel } from '../channels/in-app-notification.channel';
import { PushNotificationChannel } from '../channels/push-notification.channel';
import { EmailNotificationChannel } from '../channels/email-notification.channel';
import { SmsNotificationChannel } from '../channels/sms-notification.channel';
import { NotificationChannel } from '../constants/notification-enums.constants';

@Injectable()
export class NotificationChannelFactory {
  private readonly logger = new Logger(NotificationChannelFactory.name);
  private readonly channelsMap = new Map<NotificationChannel, INotificationChannel>();

  constructor(
    inAppChannel: InAppNotificationChannel,
    pushChannel: PushNotificationChannel,
    emailChannel: EmailNotificationChannel,
    smsChannel: SmsNotificationChannel,
  ) {
    this.channelsMap.set(NotificationChannel.IN_APP, inAppChannel);
    this.channelsMap.set(NotificationChannel.PUSH, pushChannel);
    this.channelsMap.set(NotificationChannel.EMAIL, emailChannel);
    this.channelsMap.set(NotificationChannel.SMS, smsChannel);
  }

  getChannel(type: NotificationChannel): INotificationChannel {
    const channel = this.channelsMap.get(type);
    if (!channel) {
      this.logger.error(`Notification channel ${type} not registered`);
      throw new NotFoundException(`Notification channel ${type} is not supported`);
    }
    return channel;
  }
}
