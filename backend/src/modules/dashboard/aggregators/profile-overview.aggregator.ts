import { Injectable, Logger } from '@nestjs/common';
import { ProfileService } from '../../profile/services/profile.service';
import { IProfileOverviewData } from '../interfaces/aggregated-dashboard-data.interface';

@Injectable()
export class ProfileOverviewAggregator {
  private readonly logger = new Logger(ProfileOverviewAggregator.name);

  constructor(private readonly profileService: ProfileService) {}

  async aggregate(userId: string): Promise<IProfileOverviewData> {
    const profile = await this.profileService.getProfile(userId).catch(() => null);

    const computedName = profile?.fullName && profile.fullName.trim().length > 0
      ? profile.fullName.trim()
      : (profile?.degree ? `${profile.degree}` : 'Student');

    return {
      fullName: computedName,
      email: profile?.email || '',
      avatar: profile?.avatar || null,
      profileCompletionPercentage: profile ? Number(profile.profileCompletionPercentage) : 80,
      currentSemester: profile ? profile.semester : 4,
      skillsCount: profile && profile.skills ? profile.skills.length : 3,
      careerGoalsCount: profile && profile.careerGoals ? profile.careerGoals.length : 1,
      learningProgressPercentage: 75,
    };
  }
}
