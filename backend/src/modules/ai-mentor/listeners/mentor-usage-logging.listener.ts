import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';

@Injectable()
export class MentorUsageLoggingListener {
  private readonly logger = new Logger(MentorUsageLoggingListener.name);

  @OnEvent('mentor.usage_logged', { async: true })
  handleUsageLogged(event: any): Promise<void> {
    this.logger.debug(`[AI MENTOR TELEMETRY] Provider ${event.providerName} completed for user ${event.userId} (${event.latencyMs}ms)`);
    return Promise.resolve();
  }
}
