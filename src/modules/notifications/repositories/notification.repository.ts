import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Notification } from '../entities/notification.entity';

@Injectable()
export class NotificationRepository extends BaseRepository<Notification> {
  constructor(
    @InjectRepository(Notification)
    private readonly notifRepo: Repository<Notification>,
  ) {
    super(notifRepo);
  }

  async findUserNotifications(
    userId: string,
    page: number = 1,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<{ data: Notification[]; total: number }> {
    const repo = this.getRepo(entityManager);
    const skip = (page - 1) * limit;

    const [data, total] = await repo.findAndCount({
      where: { userId },
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    return { data, total };
  }

  async countUnread(userId: string, entityManager?: EntityManager): Promise<number> {
    const repo = this.getRepo(entityManager);
    return repo.count({ where: { userId, isRead: false } });
  }

  async markAllAsRead(userId: string, entityManager?: EntityManager): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const result = await repo.update({ userId, isRead: false }, { isRead: true, readAt: new Date() });
    return (result.affected || 0) > 0;
  }
}
