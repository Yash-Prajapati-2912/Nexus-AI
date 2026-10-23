import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { AIFinanceUsageLog } from '../entities/ai-finance-usage-log.entity';

@Injectable()
export class AIFinanceUsageLogRepository extends BaseRepository<AIFinanceUsageLog> {
  constructor(
    @InjectRepository(AIFinanceUsageLog)
    private readonly logRepo: Repository<AIFinanceUsageLog>,
  ) {
    super(logRepo);
  }
}
