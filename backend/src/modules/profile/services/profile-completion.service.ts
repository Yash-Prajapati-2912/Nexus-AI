import { Injectable } from '@nestjs/common';
import { UserProfile } from '../entities/user-profile.entity';
import { PROFILE_COMPLETION_WEIGHTS } from '../constants/profile.constants';
import { IProfileCompletionBreakdown } from '../interfaces/profile-completion-weight.interface';

@Injectable()
export class ProfileCompletionService {
  /**
   * Calculates dynamic profile completion breakdown and total percentage.
   */
  calculateCompletion(profile: UserProfile): IProfileCompletionBreakdown {
    // 1. Basic Info Score (Max 35%)
    const basicFields = [
      profile.bio,
      profile.dateOfBirth,
      profile.gender,
      profile.phone,
      profile.country,
      profile.city,
      profile.university,
      profile.degree,
      profile.department,
      profile.semester,
      profile.graduationYear,
    ];

    const filledBasicCount = basicFields.filter(
      (val) => val !== null && val !== undefined && val !== '',
    ).length;

    const basicInfoScore = Math.round(
      (filledBasicCount / basicFields.length) * PROFILE_COMPLETION_WEIGHTS.BASIC_INFO,
    );

    // 2. Avatar Score (Max 10%)
    const avatarScore =
      profile.avatar && profile.avatar.trim() !== ''
        ? PROFILE_COMPLETION_WEIGHTS.AVATAR
        : 0;

    // 3. Education Score (Max 15%)
    const educationScore =
      profile.educationHistory && profile.educationHistory.length > 0
        ? PROFILE_COMPLETION_WEIGHTS.EDUCATION
        : 0;

    // 4. Skills Score (Max 15%)
    const skillsScore =
      profile.skills && profile.skills.length > 0
        ? PROFILE_COMPLETION_WEIGHTS.SKILLS
        : 0;

    // 5. Career Goals Score (Max 15%)
    const careerGoalsScore =
      profile.careerGoals && profile.careerGoals.length > 0
        ? PROFILE_COMPLETION_WEIGHTS.CAREER_GOALS
        : 0;

    // 6. Preferences Score (Max 10%)
    const preferencesScore = profile.preferences
      ? PROFILE_COMPLETION_WEIGHTS.PREFERENCES
      : 0;

    const totalPercentage = Math.min(
      100,
      basicInfoScore +
        avatarScore +
        educationScore +
        skillsScore +
        careerGoalsScore +
        preferencesScore,
    );

    return {
      basicInfoScore,
      avatarScore,
      educationScore,
      skillsScore,
      careerGoalsScore,
      preferencesScore,
      totalPercentage,
    };
  }
}
