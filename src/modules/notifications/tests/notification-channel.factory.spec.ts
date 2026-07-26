import { NotificationChannelFactory } from '../providers/notification-channel.factory';
import { InAppNotificationChannel } from '../channels/in-app-notification.channel';
import { PushNotificationChannel } from '../channels/push-notification.channel';
import { EmailNotificationChannel } from '../channels/email-notification.channel';
import { SmsNotificationChannel } from '../channels/sms-notification.channel';
import { NotificationChannel } from '../constants/notification-enums.constants';

describe('NotificationChannelFactory', () => {
  let factory: NotificationChannelFactory;

  beforeEach(() => {
    factory = new NotificationChannelFactory(
      new InAppNotificationChannel(),
      new PushNotificationChannel(),
      new EmailNotificationChannel(),
      new SmsNotificationChannel(),
    );
  });

  it('should resolve push notification channel strategy', () => {
    const channel = factory.getChannel(NotificationChannel.PUSH);
    expect(channel.channelType).toBe(NotificationChannel.PUSH);
  });

  it('should resolve email notification channel strategy', () => {
    const channel = factory.getChannel(NotificationChannel.EMAIL);
    expect(channel.channelType).toBe(NotificationChannel.EMAIL);
  });
});
