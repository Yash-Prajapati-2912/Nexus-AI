import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { BudgetRecommendation } from '../entities/budget-recommendation.entity';

@Injectable()
export class BudgetRecommendationRepository extends BaseRepository<BudgetRecommendation> {
  constructor(
    @InjectRepository(BudgetRecommendation)
    private readonly recRepo: Repository<BudgetRecommendation>,
  ) {
    super(recRepo);
  }

  async findUserRecommendations(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<BudgetRecommendation[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
