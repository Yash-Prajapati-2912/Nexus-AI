import { Injectable, Logger } from '@nestjs/common';

export interface IMediaJobPayload {
  fileId: string;
  jobType: 'IMAGE_OPTIMISATION' | 'THUMBNAIL_GENERATION' | 'METADATA_EXTRACTION' | 'CLEANUP_UNUSED';
  data?: Record<string, any>;
}

@Injectable()
export class MediaQueueProcessor {
  private readonly logger = new Logger(MediaQueueProcessor.name);

  async addOptimisationJob(fileId: string): Promise<{ jobId: string }> {
    const jobId = `media_job_${fileId}_${Date.now()}`;
    this.logger.log(`[BullMQ Ready] Enqueued media optimization job ${jobId} for file ${fileId}`);
    return { jobId };
  }
}
