import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { AIFinancialAnalysis } from '../entities/ai-financial-analysis.entity';

@Injectable()
export class AIFinancialAnalysisRepository extends BaseRepository<AIFinancialAnalysis> {
  constructor(
    @InjectRepository(AIFinancialAnalysis)
    private readonly analysisRepo: Repository<AIFinancialAnalysis>,
  ) {
    super(analysisRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<AIFinancialAnalysis | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
