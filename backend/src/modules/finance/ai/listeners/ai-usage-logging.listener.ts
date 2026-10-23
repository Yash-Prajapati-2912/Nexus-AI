import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class AIUsageLoggingListener {
  private readonly logger = new Logger(AIUsageLoggingListener.name);

  @OnEvent('finance.ai.usage_logged', { async: true })
  handleUsageLogged(event: any): Promise<void> {
    this.logger.debug(`[AI TELEMETRY] Provider ${event.providerName} execution completed for user ${event.userId} (${event.latencyMs}ms)`);
    return Promise.resolve();
  }
}
