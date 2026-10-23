import { AuditLogService } from '../services/audit-log.service';
import { AuditActionType } from '../constants/settings-enums.constants';

describe('AuditLogService', () => {
  let service: AuditLogService;
  let mockAuditRepo: any;

  beforeEach(() => {
    mockAuditRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'a-1' })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
      findUserAuditLogs: jest.fn().mockResolvedValue([{ id: 'a-1', action: AuditActionType.SETTINGS_UPDATE }]),
    };

    service = new AuditLogService(mockAuditRepo);
  });

  it('should record an audit log action', async () => {
    await service.logAction('usr-1', AuditActionType.SETTINGS_UPDATE, 'UserSetting', 's-1', { theme: 'DARK' });
    expect(mockAuditRepo.save).toHaveBeenCalled();
  });

  it('should retrieve audit logs', async () => {
    const logs = await service.getAuditLogs('usr-1');
    expect(logs.length).toBe(1);
    expect(logs[0].action).toBe(AuditActionType.SETTINGS_UPDATE);
  });
});
