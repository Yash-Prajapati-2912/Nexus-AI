import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class AINotificationListener {
  private readonly logger = new Logger(AINotificationListener.name);

  @OnEvent('finance.ai.overspending_detected', { async: true })
  handleOverspendingDetected(event: any): Promise<void> {
    this.logger.warn(`[NOTIFICATION READY] Overspending risk alert for user ${event.userId}: ${event.summary}`);
    return Promise.resolve();
  }
}
