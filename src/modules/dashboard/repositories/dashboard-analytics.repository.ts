import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { DashboardAnalytics } from '../entities/dashboard-analytics.entity';

@Injectable()
export class DashboardAnalyticsRepository extends BaseRepository<DashboardAnalytics> {
  constructor(
    @InjectRepository(DashboardAnalytics)
    private readonly analyticsRepo: Repository<DashboardAnalytics>,
  ) {
    super(analyticsRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DashboardAnalytics | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
