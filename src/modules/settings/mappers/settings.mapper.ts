import { UserSetting } from '../entities/user-setting.entity';
import { UserSessionSetting } from '../entities/user-session-setting.entity';
import { SettingsResponseDto } from '../dto/settings-response.dto';
import { SecuritySettingsResponseDto } from '../dto/security-settings-response.dto';

export class SettingsMapper {
  static toSettingsResponseDto(entity: UserSetting): SettingsResponseDto {
    return {
      id: entity.id,
      userId: entity.userId,
      theme: entity.theme,
      language: entity.language,
      timezone: entity.timezone,
      dateFormat: entity.dateFormat,
      timeFormat: entity.timeFormat,
      startOfWeek: entity.startOfWeek,
      privacySettings: entity.privacySettings,
    };
  }

  static toSecurityResponseDto(entity: UserSessionSetting): SecuritySettingsResponseDto {
    return {
      userId: entity.userId,
      sessionTimeoutMinutes: entity.sessionTimeoutMinutes,
      mfaEnabled: entity.mfaEnabled,
      trustedDevices: entity.trustedDevices,
    };
  }
}
