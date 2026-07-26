import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FinancialAnalytics } from '../entities/financial-analytics.entity';
import { AnalyticsPeriod } from '../constants/analytics-enums.constants';

@Injectable()
export class FinancialAnalyticsRepository extends BaseRepository<FinancialAnalytics> {
  constructor(
    @InjectRepository(FinancialAnalytics)
    private readonly analyticsRepo: Repository<FinancialAnalytics>,
  ) {
    super(analyticsRepo);
  }

  async findLatestForUser(
    userId: string,
    period: AnalyticsPeriod,
    entityManager?: EntityManager,
  ): Promise<FinancialAnalytics | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId, period },
      order: { endDate: 'DESC' },
    });
  }
}
