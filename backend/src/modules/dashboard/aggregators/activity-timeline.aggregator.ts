import { Injectable, Logger } from '@nestjs/common';
import { ActivityTimelineRepository } from '../repositories/activity-timeline.repository';
import { ActivityTimeline } from '../entities/activity-timeline.entity';

@Injectable()
export class ActivityTimelineAggregator {
  private readonly logger = new Logger(ActivityTimelineAggregator.name);

  constructor(private readonly timelineRepository: ActivityTimelineRepository) {}

  async aggregate(userId: string, limit: number = 20): Promise<ActivityTimeline[]> {
    return this.timelineRepository.findUserTimeline(userId, limit);
  }
}
