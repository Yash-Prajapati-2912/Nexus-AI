import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { MentorInsight } from '../entities/mentor-insight.entity';

@Injectable()
export class MentorInsightRepository extends BaseRepository<MentorInsight> {
  constructor(
    @InjectRepository(MentorInsight)
    private readonly insightRepo: Repository<MentorInsight>,
  ) {
    super(insightRepo);
  }

  async findUserInsights(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<MentorInsight[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
