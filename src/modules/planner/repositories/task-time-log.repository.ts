import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { TaskTimeLog } from '../entities/task-time-log.entity';

@Injectable()
export class TaskTimeLogRepository extends BaseRepository<TaskTimeLog> {
  constructor(
    @InjectRepository(TaskTimeLog)
    private readonly timeLogRepository: Repository<TaskTimeLog>,
  ) {
    super(timeLogRepository);
  }

  async findByUserIdAndDateRange(
    userId: string,
    taskId?: string,
    startDate?: Date,
    endDate?: Date,
    entityManager?: EntityManager,
  ): Promise<TaskTimeLog[]> {
    const repo = this.getRepo(entityManager);
    const qb = repo
      .createQueryBuilder('log')
      .where('log.user_id = :userId', { userId })
      .andWhere('log.deleted_at IS NULL');

    if (taskId) {
      qb.andWhere('log.task_id = :taskId', { taskId });
    }

    if (startDate && endDate) {
      qb.andWhere('log.start_time >= :startDate AND log.end_time <= :endDate', {
        startDate,
        endDate,
      });
    }

    qb.orderBy('log.start_time', 'DESC');

    return qb.getMany();
  }
}
