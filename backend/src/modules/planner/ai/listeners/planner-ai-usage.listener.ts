import { Injectable, Logger } from '@nestjs/common';
import { AIUsageLogRepository } from '../repositories/ai-usage-log.repository';

@Injectable()
export class PlannerAIUsageListener {
  private readonly logger = new Logger(PlannerAIUsageListener.name);

  constructor(private readonly usageLogRepository: AIUsageLogRepository) {}

  async logUsage(
    userId: string,
    actionType: any,
    providerName: string,
    promptTokens: number,
    completionTokens: number,
    latencyMs: number,
  ): Promise<void> {
    try {
      const log = this.usageLogRepository.create(
        {
          userId,
          actionType,
          providerName,
          promptTokens,
          completionTokens,
          latencyMs,
        },
        userId,
      );
      await this.usageLogRepository.save(log, userId);
      this.logger.log(`AI Usage Logged: User ${userId} | ${actionType} | ${latencyMs}ms`);
    } catch (err: any) {
      this.logger.error(`Failed to log AI usage: ${err.message}`);
    }
  }
}
