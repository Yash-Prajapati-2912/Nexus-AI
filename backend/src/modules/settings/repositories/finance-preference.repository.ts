import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FinancePreference } from '../entities/finance-preference.entity';

@Injectable()
export class FinancePreferenceRepository extends BaseRepository<FinancePreference> {
  constructor(
    @InjectRepository(FinancePreference)
    private readonly financePrefRepo: Repository<FinancePreference>,
  ) {
    super(financePrefRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<FinancePreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
