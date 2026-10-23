import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { SpendingPrediction } from '../entities/spending-prediction.entity';

@Injectable()
export class SpendingPredictionRepository extends BaseRepository<SpendingPrediction> {
  constructor(
    @InjectRepository(SpendingPrediction)
    private readonly predictionRepo: Repository<SpendingPrediction>,
  ) {
    super(predictionRepo);
  }

  async findLatestForUserAndPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<SpendingPrediction | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId, month, year },
      order: { createdAt: 'DESC' },
    });
  }
}
