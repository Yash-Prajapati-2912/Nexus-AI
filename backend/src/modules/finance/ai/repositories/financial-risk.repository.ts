import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { FinancialRisk } from '../entities/financial-risk.entity';

@Injectable()
export class FinancialRiskRepository extends BaseRepository<FinancialRisk> {
  constructor(
    @InjectRepository(FinancialRisk)
    private readonly riskRepo: Repository<FinancialRisk>,
  ) {
    super(riskRepo);
  }

  async findUserRisks(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<FinancialRisk[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { riskLevel: 'DESC', createdAt: 'DESC' },
    });
  }
}
