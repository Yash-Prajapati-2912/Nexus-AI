import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ProfileActivity } from '../entities/profile-activity.entity';

@Injectable()
export class ProfileActivityRepository extends BaseRepository<ProfileActivity> {
  constructor(
    @InjectRepository(ProfileActivity)
    private readonly activityRepository: Repository<ProfileActivity>,
  ) {
    super(activityRepository);
  }

  async findByProfileIdPaginated(
    profileId: string,
    page: number = 1,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<{ data: ProfileActivity[]; total: number }> {
    const repo = this.getRepo(entityManager);
    const skip = (page - 1) * limit;

    const [data, total] = await repo.findAndCount({
      where: { profileId },
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    return { data, total };
  }
}
