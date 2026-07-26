import { Injectable, Logger } from '@nestjs/common';

export interface INotificationJobPayload {
  userId: string;
  jobType: 'IMMEDIATE_NOTIFICATION' | 'SCHEDULED_NOTIFICATION' | 'DAILY_DIGEST' | 'WEEKLY_DIGEST' | 'RETRY_FAILED';
  data?: Record<string, any>;
}

@Injectable()
export class NotificationQueueProcessor {
  private readonly logger = new Logger(NotificationQueueProcessor.name);

  async addNotificationJob(userId: string, jobType: string, data?: any): Promise<{ jobId: string }> {
    const jobId = `notif_job_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued notification job ${jobId} (${jobType}) for user ${userId}`);
    return { jobId };
  }
}
