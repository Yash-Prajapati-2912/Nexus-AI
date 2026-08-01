import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Reminder } from '../entities/reminder.entity';
import { ReminderStatus } from '../constants/reminder-enums';

@Injectable()
export class ReminderRepository extends BaseRepository<Reminder> {
  constructor(
    @InjectRepository(Reminder)
    private readonly reminderRepository: Repository<Reminder>,
  ) {
    super(reminderRepository);
  }

  async findUpcomingForUser(
    userId: string,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<Reminder[]> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('reminder')
      .where('reminder.user_id = :userId', { userId })
      .andWhere('reminder.status = :status', { status: ReminderStatus.PENDING })
      .andWhere('reminder.deleted_at IS NULL')
      .orderBy('reminder.remindAt', 'ASC')
      .take(limit)
      .getMany();
  }
}
