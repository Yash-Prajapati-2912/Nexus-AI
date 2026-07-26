import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MonthlySummary } from '../entities/monthly-summary.entity';

@Injectable()
export class MonthlySummaryRepository extends BaseRepository<MonthlySummary> {
  constructor(
    @InjectRepository(MonthlySummary)
    private readonly summaryRepo: Repository<MonthlySummary>,
  ) {
    super(summaryRepo);
  }

  async findByUserAndPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<MonthlySummary | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId, month, year },
    });
  }
}
