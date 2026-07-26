import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class MentorDashboardUpdateListener {
  private readonly logger = new Logger(MentorDashboardUpdateListener.name);

  @OnEvent('mentor.recommendation_generated', { async: true })
  handleRecommendationGenerated(event: any): Promise<void> {
    this.logger.debug(`[MENTOR DASHBOARD] New recommendation card generated for user ${event.userId}: ${event.title}`);
    return Promise.resolve();
  }
}
