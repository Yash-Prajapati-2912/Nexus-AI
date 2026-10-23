import { Injectable, NotFoundException } from '@nestjs/common';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserDocumentRepository } from '../repositories/user-document.repository';
import { ProfileAnalyticsResponseDto } from '../dto/profile-analytics-response.dto';

@Injectable()
export class ProfileAnalyticsService {
  constructor(
    private readonly profileRepository: UserProfileRepository,
    private readonly documentRepository: UserDocumentRepository,
  ) {}

  async getProfileAnalytics(userId: string): Promise<ProfileAnalyticsResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, [
      'educationHistory',
      'skills',
      'careerGoals',
      'documents',
    ]);

    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    const primaryResume = await this.documentRepository.findPrimaryResume(profile.id);
    const now = new Date();
    const createdAt = new Date(profile.createdAt);
    const ageMs = now.getTime() - createdAt.getTime();
    const accountAgeDays = Math.max(0, Math.floor(ageMs / (1000 * 60 * 60 * 24)));

    const dto = new ProfileAnalyticsResponseDto();
    dto.profileId = profile.id;
    dto.profileCompletionPercentage = Number(profile.profileCompletionPercentage) || 0;
    dto.hasAvatar = Boolean(profile.avatar && profile.avatar.trim() !== '');
    dto.avatarUrl = profile.avatar;
    dto.educationCount = profile.educationHistory ? profile.educationHistory.length : 0;
    dto.skillCount = profile.skills ? profile.skills.length : 0;
    dto.careerGoalCount = profile.careerGoals ? profile.careerGoals.length : 0;
    dto.documentsUploadedCount = profile.documents ? profile.documents.length : 0;
    dto.hasPrimaryResume = Boolean(primaryResume);
    dto.accountAgeDays = accountAgeDays;
    dto.lastProfileUpdateAt = profile.updatedAt;

    return dto;
  }
}
