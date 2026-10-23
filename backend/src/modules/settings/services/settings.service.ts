import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { UserSettingRepository } from '../repositories/user-setting.repository';
import { ApplicationPreferenceRepository } from '../repositories/application-preference.repository';
import { PlannerPreferenceRepository } from '../repositories/planner-preference.repository';
import { FinancePreferenceRepository } from '../repositories/finance-preference.repository';
import { AIPreferenceRepository } from '../repositories/ai-preference.repository';
import { UserSessionSettingRepository } from '../repositories/user-session-setting.repository';

import { SettingsCacheService } from './settings-cache.service';
import { AuditLogService } from './audit-log.service';
import { UpdateUserSettingsDto } from '../dto/update-user-settings.dto';
import { UpdateSecuritySettingsDto } from '../dto/update-security-settings.dto';
import { UpdatePreferencesDto } from '../dto/update-preferences.dto';
import { SettingsResponseDto } from '../dto/settings-response.dto';
import { SecuritySettingsResponseDto } from '../dto/security-settings-response.dto';
import { PreferencesResponseDto } from '../dto/preferences-response.dto';
import { SettingsMapper } from '../mappers/settings.mapper';
import { AuditActionType } from '../constants/settings-enums.constants';

@Injectable()
export class SettingsService {
  private readonly logger = new Logger(SettingsService.name);

  constructor(
    private readonly userSettingRepo: UserSettingRepository,
    private readonly appPrefRepo: ApplicationPreferenceRepository,
    private readonly plannerPrefRepo: PlannerPreferenceRepository,
    private readonly financePrefRepo: FinancePreferenceRepository,
    private readonly aiPrefRepo: AIPreferenceRepository,
    private readonly sessionSettingRepo: UserSessionSettingRepository,
    private readonly cacheService: SettingsCacheService,
    private readonly auditLogService: AuditLogService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getUserSettings(userId: string): Promise<SettingsResponseDto> {
    let setting = await this.userSettingRepo.findByUserId(userId);
    if (!setting) {
      setting = this.userSettingRepo.create({ userId }, userId);
      setting = await this.userSettingRepo.save(setting, userId);
    }
    return SettingsMapper.toSettingsResponseDto(setting);
  }

  async updateUserSettings(
    userId: string,
    dto: UpdateUserSettingsDto,
  ): Promise<SettingsResponseDto> {
    let setting = await this.userSettingRepo.findByUserId(userId);
    if (!setting) {
      setting = this.userSettingRepo.create({ userId, ...dto }, userId);
    } else {
      Object.assign(setting, dto);
    }
    const saved = await this.userSettingRepo.save(setting, userId);

    await this.auditLogService.logAction(
      userId,
      AuditActionType.SETTINGS_UPDATE,
      'UserSetting',
      saved.id,
      dto,
    );

    await this.cacheService.invalidateUserSettings(userId);
    this.eventEmitter.emit('settings.updated', { userId });

    return SettingsMapper.toSettingsResponseDto(saved);
  }

  async getSecuritySettings(userId: string): Promise<SecuritySettingsResponseDto> {
    let sessionSetting = await this.sessionSettingRepo.findByUserId(userId);
    if (!sessionSetting) {
      sessionSetting = this.sessionSettingRepo.create({ userId }, userId);
      sessionSetting = await this.sessionSettingRepo.save(sessionSetting, userId);
    }
    return SettingsMapper.toSecurityResponseDto(sessionSetting);
  }

  async updateSecuritySettings(
    userId: string,
    dto: UpdateSecuritySettingsDto,
  ): Promise<SecuritySettingsResponseDto> {
    let sessionSetting = await this.sessionSettingRepo.findByUserId(userId);
    if (!sessionSetting) {
      sessionSetting = this.sessionSettingRepo.create({ userId, ...dto }, userId);
    } else {
      Object.assign(sessionSetting, dto);
    }
    const saved = await this.sessionSettingRepo.save(sessionSetting, userId);

    await this.auditLogService.logAction(
      userId,
      AuditActionType.SECURITY_UPDATE,
      'UserSessionSetting',
      saved.id,
      dto,
    );

    return SettingsMapper.toSecurityResponseDto(saved);
  }

  async getPreferences(userId: string): Promise<PreferencesResponseDto> {
    const [app, planner, finance, ai] = await Promise.all([
      this.appPrefRepo.findByUserId(userId),
      this.plannerPrefRepo.findByUserId(userId),
      this.financePrefRepo.findByUserId(userId),
      this.aiPrefRepo.findByUserId(userId),
    ]);

    return {
      userId,
      application: app || { defaultView: 'GRID', autoSave: true, soundEffects: true },
      planner: planner || { defaultCalendarView: 'WEEK', workingHoursStart: '09:00', workingHoursEnd: '17:00', dailyStudyHoursGoal: 4, taskSorting: 'DUE_DATE' },
      finance: finance || { defaultCurrency: 'USD', monthlyBudgetStartDay: 1, budgetWarningPercentage: 80 },
      ai: ai || { preferredProvider: 'GEMINI', responseStyle: 'BALANCED', creativityLevel: 'BALANCED', recommendationFrequency: 'DAILY' },
    };
  }

  async updatePreferences(
    userId: string,
    dto: UpdatePreferencesDto,
  ): Promise<PreferencesResponseDto> {
    if (dto.application) {
      let app = await this.appPrefRepo.findByUserId(userId);
      if (!app) app = this.appPrefRepo.create({ userId, ...dto.application }, userId);
      else Object.assign(app, dto.application);
      await this.appPrefRepo.save(app, userId);
    }

    if (dto.planner) {
      let planner = await this.plannerPrefRepo.findByUserId(userId);
      if (!planner) planner = this.plannerPrefRepo.create({ userId, ...dto.planner }, userId);
      else Object.assign(planner, dto.planner);
      await this.plannerPrefRepo.save(planner, userId);
    }

    if (dto.finance) {
      let finance = await this.financePrefRepo.findByUserId(userId);
      if (!finance) finance = this.financePrefRepo.create({ userId, ...dto.finance }, userId);
      else Object.assign(finance, dto.finance);
      await this.financePrefRepo.save(finance, userId);
    }

    if (dto.ai) {
      let ai = await this.aiPrefRepo.findByUserId(userId);
      if (!ai) ai = this.aiPrefRepo.create({ userId, ...dto.ai }, userId);
      else Object.assign(ai, dto.ai);
      await this.aiPrefRepo.save(ai, userId);
    }

    await this.auditLogService.logAction(
      userId,
      AuditActionType.PREFERENCE_UPDATE,
      'DomainPreferences',
      userId,
      dto,
    );

    this.eventEmitter.emit('preference.changed', { userId });
    return this.getPreferences(userId);
  }
}
