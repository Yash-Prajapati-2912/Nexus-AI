import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { CategoryAnalytics } from '../entities/category-analytics.entity';

@Injectable()
export class CategoryAnalyticsRepository extends BaseRepository<CategoryAnalytics> {
  constructor(
    @InjectRepository(CategoryAnalytics)
    private readonly catAnalyticsRepo: Repository<CategoryAnalytics>,
  ) {
    super(catAnalyticsRepo);
  }

  async findPeriodCategoryAnalytics(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<CategoryAnalytics[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId, month, year },
      order: { totalSpent: 'DESC' },
    });
  }
}
