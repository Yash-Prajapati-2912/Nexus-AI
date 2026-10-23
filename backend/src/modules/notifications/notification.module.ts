import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlannerModule } from '../planner/planner.module';
import { FinanceModule } from '../finance/finance.module';
import { AIMentorModule } from '../ai-mentor/ai-mentor.module';
import { DashboardModule } from '../dashboard/dashboard.module';

// Entities
import { Notification } from './entities/notification.entity';
import { NotificationPreference } from './entities/notification-preference.entity';
import { NotificationTemplate } from './entities/notification-template.entity';
import { NotificationHistory } from './entities/notification-history.entity';
import { DeviceToken } from './entities/device-token.entity';
import { ScheduledNotification } from './entities/scheduled-notification.entity';

// Repositories
import { NotificationRepository } from './repositories/notification.repository';
import { NotificationPreferenceRepository } from './repositories/notification-preference.repository';
import { NotificationTemplateRepository } from './repositories/notification-template.repository';
import { NotificationHistoryRepository } from './repositories/notification-history.repository';
import { DeviceTokenRepository } from './repositories/device-token.repository';
import { ScheduledNotificationRepository } from './repositories/scheduled-notification.repository';

// Delivery Channels & Factory
import { InAppNotificationChannel } from './channels/in-app-notification.channel';
import { PushNotificationChannel } from './channels/push-notification.channel';
import { EmailNotificationChannel } from './channels/email-notification.channel';
import { SmsNotificationChannel } from './channels/sms-notification.channel';
import { NotificationChannelFactory } from './providers/notification-channel.factory';

// Services & Reminder Engine
import { ReminderEngineService } from './services/reminder-engine.service';
import { NotificationCacheService } from './services/notification-cache.service';
import { NotificationService } from './services/notification.service';

// Queue & Controller
import { NotificationQueueProcessor } from './queues/notification.queue';
import { NotificationController } from './controllers/notification.controller';

// Event Listeners
import { PlannerNotificationListener } from './listeners/planner-notification.listener';
import { FinanceNotificationListener } from './listeners/finance-notification.listener';
import { MentorNotificationListener } from './listeners/mentor-notification.listener';
import { DashboardNotificationListener } from './listeners/dashboard-notification.listener';

@Module({
  imports: [
    PlannerModule,
    FinanceModule,
    AIMentorModule,
    DashboardModule,
    TypeOrmModule.forFeature([
      Notification,
      NotificationPreference,
      NotificationTemplate,
      NotificationHistory,
      DeviceToken,
      ScheduledNotification,
    ]),
  ],
  controllers: [NotificationController],
  providers: [
    // Repositories
    NotificationRepository,
    NotificationPreferenceRepository,
    NotificationTemplateRepository,
    NotificationHistoryRepository,
    DeviceTokenRepository,
    ScheduledNotificationRepository,

    // Channels (Strategy Pattern)
    InAppNotificationChannel,
    PushNotificationChannel,
    EmailNotificationChannel,
    SmsNotificationChannel,

    // Provider Factory
    NotificationChannelFactory,

    // Services & Reminder Engine
    ReminderEngineService,
    NotificationCacheService,
    NotificationService,

    // Queue Processor
    NotificationQueueProcessor,

    // Event Listeners
    PlannerNotificationListener,
    FinanceNotificationListener,
    MentorNotificationListener,
    DashboardNotificationListener,
  ],
  exports: [
    NotificationService,
    ReminderEngineService,
    NotificationChannelFactory,
  ],
})
export class NotificationModule {}
