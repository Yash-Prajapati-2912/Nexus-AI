import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { NotificationRepository } from '../repositories/notification.repository';
import { NotificationPreferenceRepository } from '../repositories/notification-preference.repository';
import { DeviceTokenRepository } from '../repositories/device-token.repository';
import { NotificationHistoryRepository } from '../repositories/notification-history.repository';
import { NotificationChannelFactory } from '../providers/notification-channel.factory';
import { NotificationCacheService } from '../services/notification-cache.service';
import { NotificationQueueProcessor } from '../queues/notification.queue';
import { DevicePlatform, NotificationCategory, NotificationChannel } from '../constants/notification-enums.constants';

describe('NotificationService', () => {
  let service: NotificationService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockNotifRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'n-1', isRead: false, createdAt: new Date() })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
      findUserNotifications: jest.fn().mockResolvedValue({ data: [], total: 0 }),
      countUnread: jest.fn().mockResolvedValue(2),
      findById: jest.fn().mockResolvedValue({ id: 'n-1', userId: mockUserId, isRead: false }),
      markAllAsRead: jest.fn().mockResolvedValue(true),
    };

    const mockDeviceRepo = {
      findByDeviceToken: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'd-1' })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
      findById: jest.fn().mockResolvedValue({ id: 'd-1', userId: mockUserId }),
      hardDelete: jest.fn().mockResolvedValue(true),
    };

    const mockPrefRepo = {
      findByUserId: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, pushEnabled: true })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
    };

    const mockHistoryRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'h-1' })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
    };

    const mockChannel = { send: jest.fn().mockResolvedValue({ success: true, channel: NotificationChannel.PUSH }) };
    const mockChannelFactory = { getChannel: jest.fn().mockReturnValue(mockChannel) };
    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined), invalidateUserNotifications: jest.fn().mockResolvedValue(undefined) };
    const mockQueue = { addNotificationJob: jest.fn().mockResolvedValue({ jobId: 'j-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationService,
        { provide: NotificationRepository, useValue: mockNotifRepo },
        { provide: NotificationPreferenceRepository, useValue: mockPrefRepo },
        { provide: DeviceTokenRepository, useValue: mockDeviceRepo },
        { provide: NotificationHistoryRepository, useValue: mockHistoryRepo },
        { provide: NotificationChannelFactory, useValue: mockChannelFactory },
        { provide: NotificationCacheService, useValue: mockCache },
        { provide: NotificationQueueProcessor, useValue: mockQueue },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<NotificationService>(NotificationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should register a device token', async () => {
    const res = await service.registerDevice(mockUserId, {
      deviceToken: 'token-abc',
      platform: DevicePlatform.WEB,
    });
    expect(res.success).toBe(true);
  });

  it('should send a notification', async () => {
    const notif = await service.sendNotification(
      mockUserId,
      NotificationCategory.SYSTEM_NOTIFICATION,
      'Welcome',
      'System initialized',
    );
    expect(notif.title).toBe('Welcome');
  });
});
