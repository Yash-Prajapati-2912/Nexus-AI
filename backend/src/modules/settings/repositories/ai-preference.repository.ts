import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { AIPreference } from '../entities/ai-preference.entity';

@Injectable()
export class AIPreferenceRepository extends BaseRepository<AIPreference> {
  constructor(
    @InjectRepository(AIPreference)
    private readonly aiPrefRepo: Repository<AIPreference>,
  ) {
    super(aiPrefRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<AIPreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
