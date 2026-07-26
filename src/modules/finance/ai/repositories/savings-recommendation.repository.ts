import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { SavingsRecommendation } from '../entities/savings-recommendation.entity';

@Injectable()
export class SavingsRecommendationRepository extends BaseRepository<SavingsRecommendation> {
  constructor(
    @InjectRepository(SavingsRecommendation)
    private readonly savingsRecRepo: Repository<SavingsRecommendation>,
  ) {
    super(savingsRecRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<SavingsRecommendation | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
