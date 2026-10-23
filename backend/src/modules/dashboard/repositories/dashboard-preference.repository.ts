import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { DashboardPreference } from '../entities/dashboard-preference.entity';

@Injectable()
export class DashboardPreferenceRepository extends BaseRepository<DashboardPreference> {
  constructor(
    @InjectRepository(DashboardPreference)
    private readonly prefRepo: Repository<DashboardPreference>,
  ) {
    super(prefRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DashboardPreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
