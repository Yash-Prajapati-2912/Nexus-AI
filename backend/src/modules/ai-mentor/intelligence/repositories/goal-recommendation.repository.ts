import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { GoalRecommendation } from '../entities/goal-recommendation.entity';

@Injectable()
export class GoalRecommendationRepository extends BaseRepository<GoalRecommendation> {
  constructor(
    @InjectRepository(GoalRecommendation)
    private readonly goalRepo: Repository<GoalRecommendation>,
  ) {
    super(goalRepo);
  }

  async findUserGoalPlans(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<GoalRecommendation[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { priorityScore: 'DESC', createdAt: 'DESC' },
    });
  }
}
