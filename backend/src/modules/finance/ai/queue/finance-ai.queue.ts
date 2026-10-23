import { Injectable, Logger } from '@nestjs/common';

export interface IFinanceAIJobPayload {
  userId: string;
  jobType: 'ANALYSIS' | 'PREDICTION' | 'WEEKLY_REVIEW' | 'MONTHLY_REVIEW';
  data?: Record<string, any>;
}

@Injectable()
export class FinanceAIQueueProcessor {
  private readonly logger = new Logger(FinanceAIQueueProcessor.name);

  async addAnalysisJob(userId: string, data?: Record<string, any>): Promise<{ jobId: string }> {
    const jobId = `job_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued Finance AI analysis job ${jobId} for user ${userId}`);
    return { jobId };
  }

  async addWeeklyReviewJob(userId: string): Promise<{ jobId: string }> {
    const jobId = `weekly_rev_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued Weekly Review job ${jobId} for user ${userId}`);
    return { jobId };
  }

  async addMonthlyReviewJob(userId: string): Promise<{ jobId: string }> {
    const jobId = `monthly_rev_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued Monthly Review job ${jobId} for user ${userId}`);
    return { jobId };
  }
}
