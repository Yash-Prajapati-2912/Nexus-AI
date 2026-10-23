import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { AIPlanningResult } from '../entities/ai-planning-result.entity';
import { AIPlanningActionType } from '../constants/ai-planner.constants';

@Injectable()
export class AIPlanningResultRepository extends BaseRepository<AIPlanningResult> {
  constructor(
    @InjectRepository(AIPlanningResult)
    private readonly resultRepo: Repository<AIPlanningResult>,
  ) {
    super(resultRepo);
  }

  async findLatestResult(
    userId: string,
    actionType: AIPlanningActionType,
  ): Promise<AIPlanningResult | null> {
    return this.resultRepo.findOne({
      where: { userId, actionType },
      order: { createdAt: 'DESC' },
    });
  }
}
