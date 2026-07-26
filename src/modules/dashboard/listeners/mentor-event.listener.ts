import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { DashboardCacheService } from '../services/dashboard-cache.service';

@Injectable()
export class MentorEventListener {
  private readonly logger = new Logger(MentorEventListener.name);

  constructor(private readonly cacheService: DashboardCacheService) {}

  @OnEvent('mentor.career_roadmap_generated', { async: true })
  @OnEvent('mentor.recommendation_rated', { async: true })
  async handleMentorEvent(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`Mentor event received for user ${event.userId}. Invalidating Dashboard cache.`);
      await this.cacheService.invalidateUserDashboard(event.userId);
    }
  }
}
