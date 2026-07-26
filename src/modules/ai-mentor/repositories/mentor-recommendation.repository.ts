import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MentorRecommendation } from '../entities/mentor-recommendation.entity';

@Injectable()
export class MentorRecommendationRepository extends BaseRepository<MentorRecommendation> {
  constructor(
    @InjectRepository(MentorRecommendation)
    private readonly recRepo: Repository<MentorRecommendation>,
  ) {
    super(recRepo);
  }

  async findRecentUserRecommendations(
    userId: string,
    limit: number = 10,
    entityManager?: EntityManager,
  ): Promise<MentorRecommendation[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
