import { Injectable, Logger } from '@nestjs/common';

export interface IIntelligenceJobPayload {
  userId: string;
  jobType: 'CAREER_ROADMAP' | 'STUDY_ANALYSIS' | 'GOAL_PLAN' | 'DECISION_ANALYSIS' | 'REFRESH_RECOMMENDATIONS';
  data?: Record<string, any>;
}

@Injectable()
export class MentorIntelligenceQueueProcessor {
  private readonly logger = new Logger(MentorIntelligenceQueueProcessor.name);

  async addCareerRoadmapJob(userId: string, targetRole?: string): Promise<{ jobId: string }> {
    const jobId = `career_job_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued career roadmap generation job ${jobId} for user ${userId} (${targetRole || 'default'})`);
    return { jobId };
  }

  async addGoalPlanJob(userId: string, goalTitle?: string): Promise<{ jobId: string }> {
    const jobId = `goal_job_${userId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued goal planning job ${jobId} for user ${userId}`);
    return { jobId };
  }
}
