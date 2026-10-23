import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ActivityTimeline } from '../entities/activity-timeline.entity';

@Injectable()
export class ActivityTimelineRepository extends BaseRepository<ActivityTimeline> {
  constructor(
    @InjectRepository(ActivityTimeline)
    private readonly timelineRepo: Repository<ActivityTimeline>,
  ) {
    super(timelineRepo);
  }

  async findUserTimeline(
    userId: string,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<ActivityTimeline[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { activityDate: 'DESC' },
      take: limit,
    });
  }
}
