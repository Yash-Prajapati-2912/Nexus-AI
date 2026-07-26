import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { CashFlowSummary } from '../entities/cash-flow-summary.entity';

@Injectable()
export class CashFlowSummaryRepository extends BaseRepository<CashFlowSummary> {
  constructor(
    @InjectRepository(CashFlowSummary)
    private readonly cashFlowRepo: Repository<CashFlowSummary>,
  ) {
    super(cashFlowRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<CashFlowSummary | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { endDate: 'DESC' },
    });
  }
}
