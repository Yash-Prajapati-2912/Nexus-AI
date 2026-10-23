import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class MentorNotificationListener {
  private readonly logger = new Logger(MentorNotificationListener.name);

  @OnEvent('mentor.session_started', { async: true })
  handleSessionStarted(event: any): Promise<void> {
    this.logger.debug(`[NOTIFICATION READY] AI Mentor session ${event.sessionId} started for user ${event.userId}`);
    return Promise.resolve();
  }
}
