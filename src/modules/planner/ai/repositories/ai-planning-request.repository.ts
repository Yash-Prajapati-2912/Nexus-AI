import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { AIPlanningRequest } from '../entities/ai-planning-request.entity';

@Injectable()
export class AIPlanningRequestRepository extends BaseRepository<AIPlanningRequest> {
  constructor(
    @InjectRepository(AIPlanningRequest)
    private readonly requestRepo: Repository<AIPlanningRequest>,
  ) {
    super(requestRepo);
  }
}
