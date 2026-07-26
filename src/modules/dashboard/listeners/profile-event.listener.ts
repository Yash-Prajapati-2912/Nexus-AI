import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { DashboardCacheService } from '../services/dashboard-cache.service';

@Injectable()
export class ProfileEventListener {
  private readonly logger = new Logger(ProfileEventListener.name);

  constructor(private readonly cacheService: DashboardCacheService) {}

  @OnEvent('profile.updated', { async: true })
  async handleProfileEvent(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`Profile update event received for user ${event.userId}. Invalidating Dashboard cache.`);
      await this.cacheService.invalidateUserDashboard(event.userId);
    }
  }
}
