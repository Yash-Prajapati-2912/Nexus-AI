import { Injectable } from '@nestjs/common';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileSearchQueryDto } from '../dto/profile-search-query.dto';
import { IPublicProfile } from '../interfaces/public-profile.interface';
import { ProfileMapper } from '../mappers/profile.mapper';

@Injectable()
export class ProfileSearchService {
  constructor(private readonly profileRepository: UserProfileRepository) {}

  async searchPublicProfiles(
    queryDto: ProfileSearchQueryDto,
  ): Promise<{ data: IPublicProfile[]; total: number; page: number; limit: number }> {
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, Math.min(100, queryDto.limit || 10));
    const skip = (page - 1) * limit;

    const qb = this.profileRepository
      .createQueryBuilder('profile')
      .leftJoinAndSelect('profile.preferences', 'preferences')
      .leftJoinAndSelect('profile.educationHistory', 'education')
      .leftJoinAndSelect('profile.skills', 'skills')
      .leftJoinAndSelect('profile.careerGoals', 'careerGoals')
      .where('profile.deleted_at IS NULL')
      .andWhere(
        "(preferences.privacy_settings->>'isPublicProfile')::boolean = true OR preferences.privacy_settings IS NULL",
      );

    if (queryDto.university && queryDto.university.trim() !== '') {
      qb.andWhere('LOWER(profile.university) LIKE LOWER(:university)', {
        university: `%${queryDto.university.trim()}%`,
      });
    }

    if (queryDto.degree && queryDto.degree.trim() !== '') {
      qb.andWhere('LOWER(profile.degree) LIKE LOWER(:degree)', {
        degree: `%${queryDto.degree.trim()}%`,
      });
    }

    if (queryDto.country && queryDto.country.trim() !== '') {
      qb.andWhere('LOWER(profile.country) LIKE LOWER(:country)', {
        country: `%${queryDto.country.trim()}%`,
      });
    }

    if (queryDto.city && queryDto.city.trim() !== '') {
      qb.andWhere('LOWER(profile.city) LIKE LOWER(:city)', {
        city: `%${queryDto.city.trim()}%`,
      });
    }

    if (queryDto.skill && queryDto.skill.trim() !== '') {
      qb.andWhere('LOWER(skills.name) LIKE LOWER(:skill)', {
        skill: `%${queryDto.skill.trim()}%`,
      });
    }

    if (queryDto.careerGoal && queryDto.careerGoal.trim() !== '') {
      qb.andWhere(
        '(LOWER(careerGoals.title) LIKE LOWER(:careerGoal) OR LOWER(careerGoals.target_industry) LIKE LOWER(:careerGoal))',
        { careerGoal: `%${queryDto.careerGoal.trim()}%` },
      );
    }

    qb.orderBy('profile.profileCompletionPercentage', 'DESC')
      .skip(skip)
      .take(limit);

    const [profiles, total] = await qb.getManyAndCount();

    const publicProfiles = profiles.map((p) => ProfileMapper.toPublicProfile(p));

    return {
      data: publicProfiles,
      total,
      page,
      limit,
    };
  }
}
