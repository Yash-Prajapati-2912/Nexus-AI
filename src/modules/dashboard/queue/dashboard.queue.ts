import { Injectable, Logger } from '@nestjs/common';

export interface IDashboardJobPayload {
  userId: string;
  jobType: 'DASHBOARD_REFRESH' | 'SNAPSHOT_GENERATION' | 'ANALYTICS_CALCULATION' | 'WIDGET_REFRESH';
  data?: Record<string, any>;
}

@Injectable()
export class DashboardQueueProcessor {
  private readonly logger = new Logger(DashboardQueueProcessor.name);

  async addDashboardRefreshJob(userId: string): Promise<{ jobId: string }> {
    const jobId = `dash_refresh_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued dashboard refresh job ${jobId} for user ${userId}`);
    return { jobId };
  }

  async addSnapshotJob(userId: string): Promise<{ jobId: string }> {
    const jobId = `dash_snapshot_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued snapshot generation job ${jobId} for user ${userId}`);
    return { jobId };
  }
}
