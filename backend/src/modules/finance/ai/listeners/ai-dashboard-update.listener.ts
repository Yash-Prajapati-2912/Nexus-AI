import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class AIDashboardUpdateListener {
  private readonly logger = new Logger(AIDashboardUpdateListener.name);

  @OnEvent('finance.ai.prediction_completed', { async: true })
  handlePredictionCompleted(event: any): Promise<void> {
    this.logger.debug(`[AI DASHBOARD] Refresh prediction widgets for user ${event.userId}`);
    return Promise.resolve();
  }
}
