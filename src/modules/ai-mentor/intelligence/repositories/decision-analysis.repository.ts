import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { DecisionAnalysis } from '../entities/decision-analysis.entity';

@Injectable()
export class DecisionAnalysisRepository extends BaseRepository<DecisionAnalysis> {
  constructor(
    @InjectRepository(DecisionAnalysis)
    private readonly decisionRepo: Repository<DecisionAnalysis>,
  ) {
    super(decisionRepo);
  }

  async findUserDecisions(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DecisionAnalysis[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
