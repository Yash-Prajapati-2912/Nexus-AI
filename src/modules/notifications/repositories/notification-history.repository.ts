import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { NotificationHistory } from '../entities/notification-history.entity';

@Injectable()
export class NotificationHistoryRepository extends BaseRepository<NotificationHistory> {
  constructor(
    @InjectRepository(NotificationHistory)
    private readonly historyRepo: Repository<NotificationHistory>,
  ) {
    super(historyRepo);
  }

  async findUserHistory(
    userId: string,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<NotificationHistory[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
