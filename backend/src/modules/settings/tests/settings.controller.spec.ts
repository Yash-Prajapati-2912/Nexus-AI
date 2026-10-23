import { Test, TestingModule } from '@nestjs/testing';
import { SettingsController } from '../controllers/settings.controller';
import { SettingsService } from '../services/settings.service';
import { FeatureFlagService } from '../services/feature-flag.service';
import { AuditLogService } from '../services/audit-log.service';
import { ThemeMode } from '../constants/settings-enums.constants';

describe('SettingsController', () => {
  let controller: SettingsController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockSettingsService = {
      getUserSettings: jest.fn().mockResolvedValue({ id: 's-1', userId: mockUserId, theme: ThemeMode.DARK }),
      updateUserSettings: jest.fn().mockResolvedValue({ id: 's-1', userId: mockUserId, theme: ThemeMode.LIGHT }),
      getSecuritySettings: jest.fn().mockResolvedValue({ userId: mockUserId, sessionTimeoutMinutes: 60 }),
      updateSecuritySettings: jest.fn().mockResolvedValue({ userId: mockUserId, sessionTimeoutMinutes: 120 }),
      getPreferences: jest.fn().mockResolvedValue({ userId: mockUserId, application: {} }),
      updatePreferences: jest.fn().mockResolvedValue({ userId: mockUserId, application: {} }),
    };

    const mockFeatureFlagService = {
      getAllFlags: jest.fn().mockResolvedValue([]),
      updateFlag: jest.fn().mockResolvedValue({ key: 'TEST_FLAG', isEnabled: true }),
    };

    const mockAuditLogService = {
      getAuditLogs: jest.fn().mockResolvedValue([]),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [SettingsController],
      providers: [
        { provide: SettingsService, useValue: mockSettingsService },
        { provide: FeatureFlagService, useValue: mockFeatureFlagService },
        { provide: AuditLogService, useValue: mockAuditLogService },
      ],
    }).compile();

    controller = module.get<SettingsController>(SettingsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get master user settings', async () => {
    const res = await controller.getUserSettings(mockUserId);
    expect(res.theme).toBe(ThemeMode.DARK);
  });

  it('should update master user settings', async () => {
    const res = await controller.updateUserSettings(mockUserId, { theme: ThemeMode.LIGHT });
    expect(res.theme).toBe(ThemeMode.LIGHT);
  });
});
