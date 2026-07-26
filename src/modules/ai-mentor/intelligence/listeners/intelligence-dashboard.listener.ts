import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class IntelligenceDashboardListener {
  private readonly logger = new Logger(IntelligenceDashboardListener.name);

  @OnEvent('mentor.goal_plan_created', { async: true })
  handleGoalPlanCreated(event: any): Promise<void> {
    this.logger.debug(`[DASHBOARD READY] Refresh goal planning widget for user ${event.userId}`);
    return Promise.resolve();
  }
}
