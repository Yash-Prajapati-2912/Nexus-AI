import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ProfileOnboarding } from '../entities/profile-onboarding.entity';

@Injectable()
export class ProfileOnboardingRepository extends BaseRepository<ProfileOnboarding> {
  constructor(
    @InjectRepository(ProfileOnboarding)
    private readonly onboardingRepository: Repository<ProfileOnboarding>,
  ) {
    super(onboardingRepository);
  }

  async findByProfileId(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<ProfileOnboarding | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { profileId },
    });
  }
}
