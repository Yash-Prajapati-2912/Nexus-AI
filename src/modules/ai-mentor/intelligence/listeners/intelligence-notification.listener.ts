import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class IntelligenceNotificationListener {
  private readonly logger = new Logger(IntelligenceNotificationListener.name);

  @OnEvent('mentor.study_recommendation_generated', { async: true })
  handleStudyRecGenerated(event: any): Promise<void> {
    this.logger.debug(`[NOTIFICATION READY] Study analysis complete for user ${event.userId} (${event.weakSubjects?.length || 0} subjects flagged)`);
    return Promise.resolve();
  }
}
