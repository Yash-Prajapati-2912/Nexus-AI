import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ApplicationPreference } from '../entities/application-preference.entity';

@Injectable()
export class ApplicationPreferenceRepository extends BaseRepository<ApplicationPreference> {
  constructor(
    @InjectRepository(ApplicationPreference)
    private readonly appPrefRepo: Repository<ApplicationPreference>,
  ) {
    super(appPrefRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<ApplicationPreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
