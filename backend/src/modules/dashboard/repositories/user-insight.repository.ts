import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserInsight } from '../entities/user-insight.entity';

@Injectable()
export class UserInsightRepository extends BaseRepository<UserInsight> {
  constructor(
    @InjectRepository(UserInsight)
    private readonly insightRepo: Repository<UserInsight>,
  ) {
    super(insightRepo);
  }

  async findUserInsights(
    userId: string,
    limit: number = 10,
    entityManager?: EntityManager,
  ): Promise<UserInsight[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { priorityLevel: 'DESC', createdAt: 'DESC' },
      take: limit,
    });
  }
}
