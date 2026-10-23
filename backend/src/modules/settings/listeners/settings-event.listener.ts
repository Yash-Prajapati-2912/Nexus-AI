import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { SettingsCacheService } from '../services/settings-cache.service';

@Injectable()
export class SettingsEventListener {
  private readonly logger = new Logger(SettingsEventListener.name);

  constructor(private readonly settingsCacheService: SettingsCacheService) {}

  @OnEvent('settings.updated', { async: true })
  async handleSettingsUpdated(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`SettingsEventListener: Invalidating cache and broadcasting settings updates for user ${event.userId}`);
      await this.settingsCacheService.invalidateUserSettings(event.userId);
    }
  }

  @OnEvent('preference.changed', { async: true })
  async handlePreferenceChanged(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`SettingsEventListener: Domain preferences changed for user ${event.userId}`);
    }
  }
}
