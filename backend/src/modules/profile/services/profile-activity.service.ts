import { Injectable, NotFoundException } from '@nestjs/common';
import { ProfileActivityRepository } from '../repositories/profile-activity.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ActivityTimelineResponseDto } from '../dto/activity-timeline-response.dto';
import { ActivityMapper } from '../mappers/activity.mapper';

@Injectable()
export class ProfileActivityService {
  constructor(
    private readonly activityRepository: ProfileActivityRepository,
    private readonly profileRepository: UserProfileRepository,
  ) {}

  async getActivityTimeline(
    userId: string,
    page: number = 1,
    limit: number = 20,
  ): Promise<{ data: ActivityTimelineResponseDto[]; total: number; page: number; limit: number }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const { data, total } = await this.activityRepository.findByProfileIdPaginated(
      profile.id,
      page,
      limit,
    );

    return {
      data: ActivityMapper.toDtoList(data),
      total,
      page,
      limit,
    };
  }
}
