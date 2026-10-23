import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager, LessThanOrEqual } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ScheduledNotification } from '../entities/scheduled-notification.entity';

@Injectable()
export class ScheduledNotificationRepository extends BaseRepository<ScheduledNotification> {
  constructor(
    @InjectRepository(ScheduledNotification)
    private readonly scheduledRepo: Repository<ScheduledNotification>,
  ) {
    super(scheduledRepo);
  }

  async findPendingScheduled(
    now: Date = new Date(),
    entityManager?: EntityManager,
  ): Promise<ScheduledNotification[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: {
        isProcessed: false,
        scheduledFor: LessThanOrEqual(now),
      },
    });
  }
}
