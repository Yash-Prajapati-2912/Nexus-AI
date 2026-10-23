import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserPreference } from '../entities/user-preference.entity';

@Injectable()
export class UserPreferenceRepository extends BaseRepository<UserPreference> {
  constructor(
    @InjectRepository(UserPreference)
    private readonly userPreferenceRepository: Repository<UserPreference>,
  ) {
    super(userPreferenceRepository);
  }

  async findByProfileId(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<UserPreference | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { profileId },
    });
  }
}
