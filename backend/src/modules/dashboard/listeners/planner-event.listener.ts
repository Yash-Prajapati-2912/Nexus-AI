import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { DashboardCacheService } from '../services/dashboard-cache.service';

@Injectable()
export class PlannerEventListener {
  private readonly logger = new Logger(PlannerEventListener.name);

  constructor(private readonly cacheService: DashboardCacheService) {}

  @OnEvent('planner.task_completed', { async: true })
  @OnEvent('planner.assignment_created', { async: true })
  async handlePlannerEvent(event: any): Promise<void> {
    if (event && event.userId) {
      this.logger.log(`Planner event received for user ${event.userId}. Invalidating Dashboard cache.`);
      await this.cacheService.invalidateUserDashboard(event.userId);
    }
  }
}
