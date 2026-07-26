import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FeatureFlag } from '../entities/feature-flag.entity';

@Injectable()
export class FeatureFlagRepository extends BaseRepository<FeatureFlag> {
  constructor(
    @InjectRepository(FeatureFlag)
    private readonly flagRepo: Repository<FeatureFlag>,
  ) {
    super(flagRepo);
  }

  async findByKey(
    key: string,
    entityManager?: EntityManager,
  ): Promise<FeatureFlag | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { key } });
  }

  async findAllFlags(entityManager?: EntityManager): Promise<FeatureFlag[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({ order: { key: 'ASC' } });
  }
}
