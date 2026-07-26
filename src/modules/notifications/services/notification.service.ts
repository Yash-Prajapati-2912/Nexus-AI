import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotificationRepository } from '../repositories/notification.repository';
import { NotificationPreferenceRepository } from '../repositories/notification-preference.repository';
import { DeviceTokenRepository } from '../repositories/device-token.repository';
import { NotificationHistoryRepository } from '../repositories/notification-history.repository';
import { NotificationChannelFactory } from '../providers/notification-channel.factory';
import { NotificationCacheService } from './notification-cache.service';
import { NotificationQueueProcessor } from '../queues/notification.queue';

import { RegisterDeviceDto } from '../dto/register-device.dto';
import { UpdatePreferencesDto } from '../dto/update-preferences.dto';
import { SendTestNotificationDto } from '../dto/send-test-notification.dto';
import { NotificationResponseDto } from '../dto/notification-response.dto';
import { NotificationPreferenceResponseDto } from '../dto/notification-preference-response.dto';
import { NotificationMapper } from '../mappers/notification.mapper';
import {
  NotificationCategory,
  NotificationChannel,
  NotificationStatus,
} from '../constants/notification-enums.constants';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(
    private readonly notificationRepository: NotificationRepository,
    private readonly preferenceRepository: NotificationPreferenceRepository,
    private readonly deviceRepository: DeviceTokenRepository,
    private readonly historyRepository: NotificationHistoryRepository,
    private readonly channelFactory: NotificationChannelFactory,
    private readonly cacheService: NotificationCacheService,
    private readonly queueProcessor: NotificationQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async registerDevice(userId: string, dto: RegisterDeviceDto) {
    const existing = await this.deviceRepository.findByDeviceToken(dto.deviceToken);

    if (existing) {
      existing.userId = userId;
      existing.platform = dto.platform;
      existing.deviceName = dto.deviceName || existing.deviceName;
      existing.lastActiveAt = new Date();
      await this.deviceRepository.save(existing, userId);
      return { success: true, deviceId: existing.id };
    }

    const device = this.deviceRepository.create(
      {
        userId,
        deviceToken: dto.deviceToken,
        platform: dto.platform,
        deviceName: dto.deviceName || null,
        lastActiveAt: new Date(),
      },
      userId,
    );

    const saved = await this.deviceRepository.save(device, userId);
    return { success: true, deviceId: saved.id };
  }

  async deleteDevice(userId: string, deviceId: string) {
    const device = await this.deviceRepository.findById(deviceId);
    if (!device || device.userId !== userId) {
      throw new NotFoundException('Device token not found');
    }
    await this.deviceRepository.hardDelete(deviceId);
    return { success: true };
  }

  async getUserNotifications(userId: string, page: number = 1, limit: number = 20) {
    const { data, total } = await this.notificationRepository.findUserNotifications(userId, page, limit);
    return {
      notifications: data.map(NotificationMapper.toNotificationDto),
      total,
      page,
      limit,
    };
  }

  async countUnread(userId: string): Promise<{ unreadCount: number }> {
    const unreadCount = await this.notificationRepository.countUnread(userId);
    return { unreadCount };
  }

  async markAsRead(userId: string, notificationId: string): Promise<{ success: boolean }> {
    const notif = await this.notificationRepository.findById(notificationId);
    if (!notif || notif.userId !== userId) {
      throw new NotFoundException('Notification not found');
    }
    notif.isRead = true;
    notif.readAt = new Date();
    await this.notificationRepository.save(notif, userId);
    await this.cacheService.invalidateUserNotifications(userId);
    return { success: true };
  }

  async markAllAsRead(userId: string): Promise<{ success: boolean }> {
    await this.notificationRepository.markAllAsRead(userId);
    await this.cacheService.invalidateUserNotifications(userId);
    return { success: true };
  }

  async getPreferences(userId: string): Promise<NotificationPreferenceResponseDto> {
    let pref = await this.preferenceRepository.findByUserId(userId);
    if (!pref) {
      pref = this.preferenceRepository.create({ userId }, userId);
      pref = await this.preferenceRepository.save(pref, userId);
    }
    return NotificationMapper.toPreferenceDto(pref);
  }

  async updatePreferences(
    userId: string,
    dto: UpdatePreferencesDto,
  ): Promise<NotificationPreferenceResponseDto> {
    let pref = await this.preferenceRepository.findByUserId(userId);
    if (!pref) {
      pref = this.preferenceRepository.create({ userId, ...dto }, userId);
    } else {
      Object.assign(pref, dto);
    }
    const saved = await this.preferenceRepository.save(pref, userId);
    return NotificationMapper.toPreferenceDto(saved);
  }

  async sendTestNotification(
    userId: string,
    dto: SendTestNotificationDto,
  ): Promise<{ success: boolean; channelResults: any[] }> {
    const channels = dto.channels || [NotificationChannel.IN_APP, NotificationChannel.PUSH];
    const results = [];

    for (const channelType of channels) {
      const channel = this.channelFactory.getChannel(channelType);
      const res = await channel.send({
        userId,
        category: NotificationCategory.SYSTEM_NOTIFICATION,
        title: dto.title || 'Test Notification',
        body: dto.body || 'This is a test multi-channel notification from Nexus AI.',
      });
      results.push(res);
    }

    return { success: true, channelResults: results };
  }

  async sendNotification(
    userId: string,
    category: NotificationCategory,
    title: string,
    body: string,
    options?: { deepLink?: string; actionButtons?: Record<string, any>[]; metadata?: Record<string, any> },
  ): Promise<NotificationResponseDto> {
    const notif = this.notificationRepository.create(
      {
        userId,
        category,
        title,
        body,
        deepLink: options?.deepLink || null,
        actionButtons: options?.actionButtons || null,
        metadata: options?.metadata || null,
      },
      userId,
    );

    const saved = await this.notificationRepository.save(notif, userId);

    // Record delivery history
    const history = this.historyRepository.create(
      {
        userId,
        channel: NotificationChannel.IN_APP,
        status: NotificationStatus.SENT,
        deliveredAt: new Date(),
        payload: { title, body },
      },
      userId,
    );
    await this.historyRepository.save(history, userId);

    return NotificationMapper.toNotificationDto(saved);
  }
}
