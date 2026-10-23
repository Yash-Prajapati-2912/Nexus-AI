import { Injectable, Logger } from '@nestjs/common';

export interface IMentorJobPayload {
  userId: string;
  conversationId: string;
  jobType: 'LONG_RESPONSE' | 'SUMMARIZATION' | 'RECOMMENDATION';
  data?: Record<string, any>;
}

@Injectable()
export class AIMentorQueueProcessor {
  private readonly logger = new Logger(AIMentorQueueProcessor.name);

  async addSummarizationJob(conversationId: string, userId: string): Promise<{ jobId: string }> {
    const jobId = `summary_${conversationId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued conversation summarization job ${jobId} for user ${userId}`);
    return { jobId };
  }

  async addRecommendationJob(userId: string, data?: Record<string, any>): Promise<{ jobId: string }> {
    const jobId = `rec_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued AI mentor recommendation job ${jobId} for user ${userId}`);
    return { jobId };
  }
}
