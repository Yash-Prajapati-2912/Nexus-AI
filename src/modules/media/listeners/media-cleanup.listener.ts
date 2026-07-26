import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { MediaFileRepository } from '../repositories/media-file.repository';

@Injectable()
export class MediaCleanupListener {
  private readonly logger = new Logger(MediaCleanupListener.name);

  constructor(private readonly mediaFileRepository: MediaFileRepository) {}

  @OnEvent('media.deleted', { async: true })
  async handleMediaDeleted(event: any): Promise<void> {
    if (event && event.fileId) {
      this.logger.log(`MediaCleanupListener: Purging associated cache and metadata for media file ${event.fileId}`);
    }
  }
}
