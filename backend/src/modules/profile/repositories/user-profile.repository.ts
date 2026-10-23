import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserProfile } from '../entities/user-profile.entity';

import { User } from '../../auth/entities/user.entity';

@Injectable()
export class UserProfileRepository extends BaseRepository<UserProfile> {
  constructor(
    @InjectRepository(UserProfile)
    private readonly userProfileRepository: Repository<UserProfile>,
  ) {
    super(userProfileRepository);
  }

  async findByUserId(
    userId: string,
    relations: string[] = ['user', 'educationHistory', 'skills', 'careerGoals', 'preferences'],
    entityManager?: EntityManager,
  ): Promise<UserProfile | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      relations,
    });
  }

  async findByProfileIdWithRelations(
    profileId: string,
    relations: string[] = ['user', 'educationHistory', 'skills', 'careerGoals', 'preferences'],
    entityManager?: EntityManager,
  ): Promise<UserProfile | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { id: profileId },
      relations,
    });
  }

  async updateCompletionPercentage(
    profileId: string,
    percentage: number,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(profileId, { profileCompletionPercentage: percentage });
  }

  async saveUser(user: User, entityManager?: EntityManager): Promise<User> {
    const repo = this.getRepo(entityManager);
    return repo.manager.save(user);
  }
}
