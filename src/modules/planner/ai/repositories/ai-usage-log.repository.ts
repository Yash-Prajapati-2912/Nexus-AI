import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { AIUsageLog } from '../entities/ai-usage-log.entity';

@Injectable()
export class AIUsageLogRepository extends BaseRepository<AIUsageLog> {
  constructor(
    @InjectRepository(AIUsageLog)
    private readonly usageLogRepo: Repository<AIUsageLog>,
  ) {
    super(usageLogRepo);
  }
}
