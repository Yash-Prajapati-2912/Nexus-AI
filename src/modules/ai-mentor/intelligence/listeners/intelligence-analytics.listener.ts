import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { CareerRoadmapGeneratedEvent } from '../events/career-roadmap-generated.event';

@Injectable()
export class IntelligenceAnalyticsListener {
  private readonly logger = new Logger(IntelligenceAnalyticsListener.name);

  @OnEvent('mentor.career_roadmap_generated', { async: true })
  handleCareerRoadmapGenerated(event: CareerRoadmapGeneratedEvent): Promise<void> {
    this.logger.log(`Intelligence Analytics: Career roadmap ${event.roadmapId} (${event.targetRole}) generated for user ${event.userId} (Score: ${event.readinessScore})`);
    return Promise.resolve();
  }
}
