import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

// Entities
import { UserSetting } from './entities/user-setting.entity';
import { ApplicationPreference } from './entities/application-preference.entity';
import { PlannerPreference } from './entities/planner-preference.entity';
import { FinancePreference } from './entities/finance-preference.entity';
import { AIPreference } from './entities/ai-preference.entity';
import { ThemePreference } from './entities/theme-preference.entity';
import { LanguagePreference } from './entities/language-preference.entity';
import { TimezonePreference } from './entities/timezone-preference.entity';
import { FeatureFlag } from './entities/feature-flag.entity';
import { UserSessionSetting } from './entities/user-session-setting.entity';
import { AuditLog } from './entities/audit-log.entity';
import { SystemSetting } from './entities/system-setting.entity';

// Repositories
import { UserSettingRepository } from './repositories/user-setting.repository';
import { ApplicationPreferenceRepository } from './repositories/application-preference.repository';
import { PlannerPreferenceRepository } from './repositories/planner-preference.repository';
import { FinancePreferenceRepository } from './repositories/finance-preference.repository';
import { AIPreferenceRepository } from './repositories/ai-preference.repository';
import { FeatureFlagRepository } from './repositories/feature-flag.repository';
import { UserSessionSettingRepository } from './repositories/user-session-setting.repository';
import { AuditLogRepository } from './repositories/audit-log.repository';
import { SystemSettingRepository } from './repositories/system-setting.repository';

// Services
import { FeatureFlagService } from './services/feature-flag.service';
import { AuditLogService } from './services/audit-log.service';
import { SettingsCacheService } from './services/settings-cache.service';
import { SettingsService } from './services/settings.service';

// Controller & Listener
import { SettingsController } from './controllers/settings.controller';
import { SettingsEventListener } from './listeners/settings-event.listener';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserSetting,
      ApplicationPreference,
      PlannerPreference,
      FinancePreference,
      AIPreference,
      ThemePreference,
      LanguagePreference,
      TimezonePreference,
      FeatureFlag,
      UserSessionSetting,
      AuditLog,
      SystemSetting,
    ]),
  ],
  controllers: [SettingsController],
  providers: [
    // Repositories
    UserSettingRepository,
    ApplicationPreferenceRepository,
    PlannerPreferenceRepository,
    FinancePreferenceRepository,
    AIPreferenceRepository,
    FeatureFlagRepository,
    UserSessionSettingRepository,
    AuditLogRepository,
    SystemSettingRepository,

    // Services
    FeatureFlagService,
    AuditLogService,
    SettingsCacheService,
    SettingsService,

    // Listeners
    SettingsEventListener,
  ],
  exports: [
    SettingsService,
    FeatureFlagService,
    AuditLogService,
  ],
})
export class SettingsModule {}
