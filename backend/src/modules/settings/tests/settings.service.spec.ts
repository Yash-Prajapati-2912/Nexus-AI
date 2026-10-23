import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { SettingsService } from '../services/settings.service';
import { UserSettingRepository } from '../repositories/user-setting.repository';
import { ApplicationPreferenceRepository } from '../repositories/application-preference.repository';
import { PlannerPreferenceRepository } from '../repositories/planner-preference.repository';
import { FinancePreferenceRepository } from '../repositories/finance-preference.repository';
import { AIPreferenceRepository } from '../repositories/ai-preference.repository';
import { UserSessionSettingRepository } from '../repositories/user-session-setting.repository';
import { SettingsCacheService } from '../services/settings-cache.service';
import { AuditLogService } from '../services/audit-log.service';
import { ThemeMode, StartOfWeek } from '../constants/settings-enums.constants';

describe('SettingsService', () => {
  let service: SettingsService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockUserSettingRepo = {
      findByUserId: jest.fn().mockResolvedValue({
        id: 's-1',
        userId: mockUserId,
        theme: ThemeMode.DARK,
        language: 'en-US',
        timezone: 'UTC',
        dateFormat: 'YYYY-MM-DD',
        timeFormat: '24h',
        startOfWeek: StartOfWeek.MONDAY,
      }),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 's-1' })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
    };

    const mockAppPrefRepo = { findByUserId: jest.fn().mockResolvedValue(null), create: jest.fn().mockImplementation((dto) => dto), save: jest.fn().mockImplementation((e) => Promise.resolve(e)) };
    const mockPlannerPrefRepo = { findByUserId: jest.fn().mockResolvedValue(null), create: jest.fn().mockImplementation((dto) => dto), save: jest.fn().mockImplementation((e) => Promise.resolve(e)) };
    const mockFinancePrefRepo = { findByUserId: jest.fn().mockResolvedValue(null), create: jest.fn().mockImplementation((dto) => dto), save: jest.fn().mockImplementation((e) => Promise.resolve(e)) };
    const mockAIPrefRepo = { findByUserId: jest.fn().mockResolvedValue(null), create: jest.fn().mockImplementation((dto) => dto), save: jest.fn().mockImplementation((e) => Promise.resolve(e)) };

    const mockSessionSettingRepo = {
      findByUserId: jest.fn().mockResolvedValue({ userId: mockUserId, sessionTimeoutMinutes: 60, mfaEnabled: false }),
      create: jest.fn().mockImplementation((dto) => dto),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
    };

    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined), invalidateUserSettings: jest.fn().mockResolvedValue(undefined) };
    const mockAuditLog = { logAction: jest.fn().mockResolvedValue(undefined) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SettingsService,
        { provide: UserSettingRepository, useValue: mockUserSettingRepo },
        { provide: ApplicationPreferenceRepository, useValue: mockAppPrefRepo },
        { provide: PlannerPreferenceRepository, useValue: mockPlannerPrefRepo },
        { provide: FinancePreferenceRepository, useValue: mockFinancePrefRepo },
        { provide: AIPreferenceRepository, useValue: mockAIPrefRepo },
        { provide: UserSessionSettingRepository, useValue: mockSessionSettingRepo },
        { provide: SettingsCacheService, useValue: mockCache },
        { provide: AuditLogService, useValue: mockAuditLog },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<SettingsService>(SettingsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should retrieve master user settings', async () => {
    const res = await service.getUserSettings(mockUserId);
    expect(res.theme).toBe(ThemeMode.DARK);
  });

  it('should update master user settings', async () => {
    const res = await service.updateUserSettings(mockUserId, { theme: ThemeMode.LIGHT });
    expect(res.theme).toBe(ThemeMode.LIGHT);
  });
});
