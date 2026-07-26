import { NotificationChannel } from '../constants/notification-enums.constants';

export interface INotificationPayload {
  userId: string;
  category: string;
  title: string;
  body: string;
  deepLink?: string;
  actionButtons?: Record<string, any>[];
  metadata?: Record<string, any>;
  emailRecipient?: string;
  deviceTokens?: string[];
}

export interface INotificationDeliveryResult {
  success: boolean;
  channel: NotificationChannel;
  messageId?: string;
  error?: string;
}

export interface INotificationChannel {
  readonly channelType: NotificationChannel;

  send(payload: INotificationPayload): Promise<INotificationDeliveryResult>;
}
