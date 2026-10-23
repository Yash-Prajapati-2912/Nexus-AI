import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FinancialTrend } from '../entities/financial-trend.entity';

@Injectable()
export class FinancialTrendRepository extends BaseRepository<FinancialTrend> {
  constructor(
    @InjectRepository(FinancialTrend)
    private readonly trendRepo: Repository<FinancialTrend>,
  ) {
    super(trendRepo);
  }

  async findUserTrends(
    userId: string,
    periodType: string = 'MONTHLY',
    limit: number = 12,
    entityManager?: EntityManager,
  ): Promise<FinancialTrend[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId, periodType },
      order: { periodLabel: 'DESC' },
      take: limit,
    });
  }
}
