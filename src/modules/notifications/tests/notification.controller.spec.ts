import { Test, TestingModule } from '@nestjs/testing';
import { NotificationController } from '../controllers/notification.controller';
import { NotificationService } from '../services/notification.service';
import { DevicePlatform } from '../constants/notification-enums.constants';

describe('NotificationController', () => {
  let controller: NotificationController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockService = {
      registerDevice: jest.fn().mockResolvedValue({ success: true, deviceId: 'd-1' }),
      deleteDevice: jest.fn().mockResolvedValue({ success: true }),
      getUserNotifications: jest.fn().mockResolvedValue({ notifications: [], total: 0 }),
      countUnread: jest.fn().mockResolvedValue({ unreadCount: 3 }),
      markAsRead: jest.fn().mockResolvedValue({ success: true }),
      markAllAsRead: jest.fn().mockResolvedValue({ success: true }),
      getPreferences: jest.fn().mockResolvedValue({ pushEnabled: true }),
      updatePreferences: jest.fn().mockResolvedValue({ pushEnabled: false }),
      sendTestNotification: jest.fn().mockResolvedValue({ success: true, channelResults: [] }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [NotificationController],
      providers: [{ provide: NotificationService, useValue: mockService }],
    }).compile();

    controller = module.get<NotificationController>(NotificationController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should register device endpoint', async () => {
    const res = await controller.registerDevice(mockUserId, {
      deviceToken: 'token-xyz',
      platform: DevicePlatform.IOS,
    });
    expect(res.success).toBe(true);
  });

  it('should count unread notifications endpoint', async () => {
    const res = await controller.countUnread(mockUserId);
    expect(res.unreadCount).toBe(3);
  });
});
