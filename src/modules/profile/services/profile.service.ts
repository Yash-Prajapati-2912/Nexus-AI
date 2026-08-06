import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserPreferenceRepository } from '../repositories/user-preference.repository';
import { CreateProfileDto } from '../dto/create-profile.dto';
import { UpdateProfileDto } from '../dto/update-profile.dto';
import { ProfileResponseDto } from '../dto/profile-response.dto';
import { ProfileMapper } from '../mappers/profile.mapper';
import { ProfileCompletionService } from './profile-completion.service';
import { DEFAULT_USER_PREFERENCES } from '../constants/profile.constants';
import { ThemePreference } from '../constants/theme.enum';
import { CurrentStatus } from '../constants/current-status.enum';
import { IPublicProfile } from '../interfaces/public-profile.interface';

import { SkillRepository } from '../repositories/skill.repository';
import { CareerGoalRepository } from '../repositories/career-goal.repository';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';
import { CareerGoalStatus } from '../constants/career-goal-status.enum';

@Injectable()
export class ProfileService {
  constructor(
    private readonly profileRepository: UserProfileRepository,
    private readonly preferenceRepository: UserPreferenceRepository,
    private readonly completionService: ProfileCompletionService,
    private readonly skillRepository: SkillRepository,
    private readonly careerGoalRepository: CareerGoalRepository,
  ) {}

  async createProfile(userId: string, dto: CreateProfileDto): Promise<ProfileResponseDto> {
    const existing = await this.profileRepository.findByUserId(userId, []);
    if (existing) {
      throw new ConflictException('Profile already exists for this user.');
    }

    const profileEntity = this.profileRepository.create(
      {
        userId,
        avatar: dto.avatar || null,
        bio: dto.bio ? dto.bio.trim() : null,
        dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : null,
        gender: dto.gender || null,
        phone: dto.phone ? dto.phone.trim() : null,
        country: dto.country ? dto.country.trim() : null,
        state: dto.state ? dto.state.trim() : null,
        city: dto.city ? dto.city.trim() : null,
        university: dto.university ? dto.university.trim() : null,
        degree: dto.degree ? dto.degree.trim() : null,
        department: dto.department ? dto.department.trim() : null,
        semester: dto.semester ?? null,
        graduationYear: dto.graduationYear ?? null,
        currentStatus: dto.currentStatus || CurrentStatus.STUDENT,
        timezone: dto.timezone ? dto.timezone.trim() : 'UTC',
        language: dto.language ? dto.language.trim() : 'en',
        profileCompletionPercentage: 0,
      },
      userId,
    );

    const savedProfile = await this.profileRepository.save(profileEntity, userId);

    // Initialize default User Preference entity if not present
    let preference = await this.preferenceRepository.findByProfileId(savedProfile.id);
    if (!preference) {
      preference = await this.preferenceRepository.save(
        {
          profileId: savedProfile.id,
          theme: ThemePreference.SYSTEM,
          language: savedProfile.language,
          notificationPreferences: DEFAULT_USER_PREFERENCES.notificationPreferences,
          studyPreferences: DEFAULT_USER_PREFERENCES.studyPreferences,
          reminderPreferences: DEFAULT_USER_PREFERENCES.reminderPreferences,
          aiPreferences: DEFAULT_USER_PREFERENCES.aiPreferences,
          privacySettings: DEFAULT_USER_PREFERENCES.privacySettings,
        },
        userId,
      );
    }

    const fullProfile = await this.profileRepository.findByProfileIdWithRelations(
      savedProfile.id,
    );

    if (fullProfile) {
      const breakdown = this.completionService.calculateCompletion(fullProfile);
      fullProfile.profileCompletionPercentage = breakdown.totalPercentage;
      await this.profileRepository.updateCompletionPercentage(
        fullProfile.id,
        breakdown.totalPercentage,
      );
      return ProfileMapper.toDto(fullProfile);
    }

    return ProfileMapper.toDto(savedProfile);
  }

  async getProfile(userId: string): Promise<ProfileResponseDto> {
    let profile = await this.profileRepository.findByUserId(userId);
    if (!profile) {
      try {
        return await this.createProfile(userId, {});
      } catch (_) {
        profile = await this.profileRepository.findByUserId(userId);
        if (!profile) {
          throw new NotFoundException('User profile not found.');
        }
      }
    }
    return ProfileMapper.toDto(profile);
  }

  async getPublicProfile(profileId: string): Promise<IPublicProfile> {
    const profile = await this.profileRepository.findByProfileIdWithRelations(profileId);
    if (!profile) {
      throw new NotFoundException(`Public profile with ID ${profileId} not found.`);
    }

    if (profile.preferences?.privacySettings?.isPublicProfile === false) {
      throw new NotFoundException(`Profile is private.`);
    }

    return ProfileMapper.toPublicProfile(profile);
  }

  async updateProfile(userId: string, dto: UpdateProfileDto): Promise<ProfileResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    if (profile.user && (dto.displayName !== undefined || dto.firstName !== undefined || dto.lastName !== undefined)) {
      if (dto.displayName !== undefined) {
        const parts = dto.displayName.trim().split(' ');
        profile.user.firstName = parts[0] || '';
        profile.user.lastName = parts.slice(1).join(' ') || '';
      }
      if (dto.firstName !== undefined) profile.user.firstName = dto.firstName.trim();
      if (dto.lastName !== undefined) profile.user.lastName = dto.lastName.trim();
      await this.profileRepository.saveUser(profile.user);
    }

    if (dto.avatar !== undefined) profile.avatar = dto.avatar || null;
    if (dto.bio !== undefined) profile.bio = dto.bio ? dto.bio.trim() : null;
    if (dto.dateOfBirth !== undefined)
      profile.dateOfBirth = dto.dateOfBirth ? new Date(dto.dateOfBirth) : null;
    if (dto.gender !== undefined) profile.gender = dto.gender || null;
    if (dto.phone !== undefined) profile.phone = dto.phone ? dto.phone.trim() : null;
    if (dto.country !== undefined) profile.country = dto.country ? dto.country.trim() : null;
    if (dto.state !== undefined) profile.state = dto.state ? dto.state.trim() : null;
    if (dto.city !== undefined) profile.city = dto.city ? dto.city.trim() : null;
    if (dto.university !== undefined)
      profile.university = dto.university ? dto.university.trim() : null;
    if (dto.degree !== undefined) profile.degree = dto.degree ? dto.degree.trim() : null;
    if (dto.department !== undefined)
      profile.department = dto.department ? dto.department.trim() : null;
    if (dto.semester !== undefined) profile.semester = dto.semester ?? null;
    if (dto.graduationYear !== undefined)
      profile.graduationYear = dto.graduationYear ?? null;
    if (dto.cgpa !== undefined)
      profile.cgpa = dto.cgpa ?? null;
    if (dto.currentStatus !== undefined) profile.currentStatus = dto.currentStatus;
    if (dto.timezone !== undefined)
      profile.timezone = dto.timezone ? dto.timezone.trim() : 'UTC';
    if (dto.language !== undefined)
      profile.language = dto.language ? dto.language.trim() : 'en';

    await this.profileRepository.save(profile, userId);

    if (dto.skills && Array.isArray(dto.skills)) {
      for (const skillName of dto.skills) {
        const nameTrimmed = skillName.trim();
        if (nameTrimmed) {
          const existing = await this.skillRepository.findByNameAndProfileId(profile.id, nameTrimmed);
          if (!existing) {
            const newSkill = this.skillRepository.create(
              {
                profileId: profile.id,
                name: nameTrimmed,
                category: SkillCategory.TECHNICAL,
                level: SkillLevel.INTERMEDIATE,
              },
              userId,
            );
            await this.skillRepository.save(newSkill, userId);
          }
        }
      }
    }

    if (dto.careerInterests && Array.isArray(dto.careerInterests)) {
      const existingGoals = await this.careerGoalRepository.findByProfileId(profile.id);
      for (const goalTitle of dto.careerInterests) {
        const titleTrimmed = goalTitle.trim();
        if (titleTrimmed) {
          const existing = existingGoals.find(
            (g) => g.title.toLowerCase() === titleTrimmed.toLowerCase(),
          );
          if (!existing) {
            const newGoal = this.careerGoalRepository.create(
              {
                profileId: profile.id,
                title: titleTrimmed,
                targetIndustry: 'Technology',
                targetYear: new Date().getFullYear() + 1,
                status: CareerGoalStatus.IN_PROGRESS,
              },
              userId,
            );
            await this.careerGoalRepository.save(newGoal, userId);
          }
        }
      }
    }

    const updatedFull = await this.profileRepository.findByProfileIdWithRelations(profile.id);
    if (updatedFull) {
      const breakdown = this.completionService.calculateCompletion(updatedFull);
      updatedFull.profileCompletionPercentage = breakdown.totalPercentage;
      await this.profileRepository.updateCompletionPercentage(
        profile.id,
        breakdown.totalPercentage,
      );
      return ProfileMapper.toDto(updatedFull);
    }

    return ProfileMapper.toDto(profile);
  }

  async deleteProfile(userId: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    await this.profileRepository.softDeleteById(profile.id, userId);
    return { success: true };
  }
}
