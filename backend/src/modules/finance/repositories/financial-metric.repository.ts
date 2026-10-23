import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FinancialMetric } from '../entities/financial-metric.entity';
import { MetricKey } from '../constants/analytics-enums.constants';

@Injectable()
export class FinancialMetricRepository extends BaseRepository<FinancialMetric> {
  constructor(
    @InjectRepository(FinancialMetric)
    private readonly metricRepo: Repository<FinancialMetric>,
  ) {
    super(metricRepo);
  }

  async findUserMetrics(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<FinancialMetric[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { calculatedAt: 'DESC' },
    });
  }

  async upsertMetric(
    userId: string,
    metricKey: MetricKey,
    metricValue: string,
    period: string = 'MONTHLY',
    entityManager?: EntityManager,
  ): Promise<FinancialMetric> {
    const repo = this.getRepo(entityManager);
    let metric = await repo.findOne({
      where: { userId, metricKey, period },
    });

    if (!metric) {
      metric = repo.create({
        userId,
        metricKey,
        metricValue,
        period,
        calculatedAt: new Date(),
      });
    } else {
      metric.metricValue = metricValue;
      metric.calculatedAt = new Date();
    }

    return repo.save(metric);
  }
}
