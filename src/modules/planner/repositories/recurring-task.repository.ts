import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { RecurringTask } from '../entities/recurring-task.entity';

@Injectable()
export class RecurringTaskRepository extends BaseRepository<RecurringTask> {
  constructor(
    @InjectRepository(RecurringTask)
    private readonly recurringTaskRepository: Repository<RecurringTask>,
  ) {
    super(recurringTaskRepository);
  }

  async findActiveByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<RecurringTask[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId, isPaused: false },
      order: { nextOccurrenceAt: 'ASC' },
    });
  }
}
