import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { PlannerPreference } from '../entities/planner-preference.entity';

@Injectable()
export class PlannerPreferenceRepository extends BaseRepository<PlannerPreference> {
  constructor(
    @InjectRepository(PlannerPreference)
    private readonly plannerPrefRepo: Repository<PlannerPreference>,
  ) {
    super(plannerPrefRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<PlannerPreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
