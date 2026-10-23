import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaUsage } from '../entities/media-usage.entity';

@Injectable()
export class MediaUsageRepository extends BaseRepository<MediaUsage> {
  constructor(
    @InjectRepository(MediaUsage)
    private readonly usageRepo: Repository<MediaUsage>,
  ) {
    super(usageRepo);
  }

  async findUserUsage(
    userId: string,
    moduleName: string = 'ALL',
    entityManager?: EntityManager,
  ): Promise<MediaUsage | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId, moduleName } });
  }
}
