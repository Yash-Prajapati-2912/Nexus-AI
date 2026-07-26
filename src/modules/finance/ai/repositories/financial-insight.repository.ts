import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { FinancialInsight } from '../entities/financial-insight.entity';

@Injectable()
export class FinancialInsightRepository extends BaseRepository<FinancialInsight> {
  constructor(
    @InjectRepository(FinancialInsight)
    private readonly insightRepo: Repository<FinancialInsight>,
  ) {
    super(insightRepo);
  }

  async findUserInsights(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<FinancialInsight[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { priority: 'ASC', createdAt: 'DESC' },
    });
  }
}
