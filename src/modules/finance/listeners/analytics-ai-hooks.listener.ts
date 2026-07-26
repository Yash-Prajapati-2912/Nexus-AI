import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { ANALYTICS_EVENTS } from '../constants/analytics-events.constants';

@Injectable()
export class AnalyticsAIHooksListener {
  private readonly logger = new Logger(AnalyticsAIHooksListener.name);

  @OnEvent(ANALYTICS_EVENTS.TREND_CALCULATED, { async: true })
  handleTrendCalculated(event: any): Promise<void> {
    this.logger.debug(`[AI FINANCIAL ADVISOR HOOK] Trend payload available for user ${event.userId} period ${event.periodLabel}`);
    return Promise.resolve();
  }

  @OnEvent(ANALYTICS_EVENTS.BUDGET_THRESHOLD_REACHED, { async: true })
  handleBudgetThreshold(event: any): Promise<void> {
    this.logger.debug(`[AI FINANCIAL ADVISOR HOOK] Budget alert payload ready for AI analysis: ${event.message}`);
    return Promise.resolve();
  }
}
