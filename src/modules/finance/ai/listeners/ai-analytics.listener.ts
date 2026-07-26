import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FinancialSummaryGeneratedEvent } from '../events/financial-summary-generated.event';

@Injectable()
export class AIAnalyticsListener {
  private readonly logger = new Logger(AIAnalyticsListener.name);

  @OnEvent('finance.ai.summary_generated', { async: true })
  handleSummaryGenerated(event: FinancialSummaryGeneratedEvent): Promise<void> {
    this.logger.log(`AI Analytics Listener: Financial Summary ${event.analysisId} recorded for user ${event.userId}`);
    return Promise.resolve();
  }
}
