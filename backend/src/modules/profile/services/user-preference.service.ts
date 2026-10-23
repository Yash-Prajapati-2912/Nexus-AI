import { Injectable, NotFoundException } from '@nestjs/common';
import { UserPreferenceRepository } from '../repositories/user-preference.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UpdateUserPreferenceDto } from '../dto/update-user-preference.dto';
import { UserPreferenceResponseDto } from '../dto/user-preference-response.dto';
import { UserPreferenceMapper } from '../mappers/user-preference.mapper';
import { DEFAULT_USER_PREFERENCES } from '../constants/profile.constants';
import { ProfileCompletionService } from './profile-completion.service';
import { ThemePreference } from '../constants/theme.enum';
import {
  INotificationPreferences,
  IStudyPreferences,
  IReminderPreferences,
  IAiPreferences,
  IPrivacySettings,
} from '../interfaces/user-preference.interface';

@Injectable()
export class UserPreferenceService {
  constructor(
    private readonly preferenceRepository: UserPreferenceRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly completionService: ProfileCompletionService,
  ) {}

  async getPreferences(userId: string): Promise<UserPreferenceResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    let preferences = await this.preferenceRepository.findByProfileId(profile.id);

    if (!preferences) {
      // Auto-initialize default preferences if not yet created
      preferences = await this.preferenceRepository.save(
        {
          profileId: profile.id,
          theme: ThemePreference.SYSTEM,
          language: DEFAULT_USER_PREFERENCES.language,
          notificationPreferences: DEFAULT_USER_PREFERENCES.notificationPreferences,
          studyPreferences: DEFAULT_USER_PREFERENCES.studyPreferences,
          reminderPreferences: DEFAULT_USER_PREFERENCES.reminderPreferences,
          aiPreferences: DEFAULT_USER_PREFERENCES.aiPreferences,
          privacySettings: DEFAULT_USER_PREFERENCES.privacySettings,
        },
        userId,
      );

      await this.recalculateProfileCompletion(profile.id);
    }

    return UserPreferenceMapper.toDto(preferences);
  }

  async updatePreferences(
    userId: string,
    dto: UpdateUserPreferenceDto,
  ): Promise<UserPreferenceResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    let preferences = await this.preferenceRepository.findByProfileId(profile.id);

    if (!preferences) {
      const initialNotifications: INotificationPreferences = {
        ...DEFAULT_USER_PREFERENCES.notificationPreferences,
        ...(dto.notificationPreferences || {}),
      };
      const initialStudy: IStudyPreferences = {
        ...DEFAULT_USER_PREFERENCES.studyPreferences,
        ...(dto.studyPreferences || {}),
      };
      const initialReminder: IReminderPreferences = {
        ...DEFAULT_USER_PREFERENCES.reminderPreferences,
        ...(dto.reminderPreferences || {}),
      };
      const initialAi: IAiPreferences = {
        ...DEFAULT_USER_PREFERENCES.aiPreferences,
        ...(dto.aiPreferences || {}),
      };
      const initialPrivacy: IPrivacySettings = {
        ...DEFAULT_USER_PREFERENCES.privacySettings,
        ...(dto.privacySettings || {}),
      };

      preferences = this.preferenceRepository.create(
        {
          profileId: profile.id,
          theme: dto.theme || ThemePreference.SYSTEM,
          language: dto.language || DEFAULT_USER_PREFERENCES.language,
          notificationPreferences: initialNotifications,
          studyPreferences: initialStudy,
          reminderPreferences: initialReminder,
          aiPreferences: initialAi,
          privacySettings: initialPrivacy,
        },
        userId,
      );
    } else {
      if (dto.theme) preferences.theme = dto.theme;
      if (dto.language) preferences.language = dto.language;

      if (dto.notificationPreferences) {
        preferences.notificationPreferences = {
          ...preferences.notificationPreferences,
          ...dto.notificationPreferences,
        };
      }

      if (dto.studyPreferences) {
        preferences.studyPreferences = {
          ...preferences.studyPreferences,
          ...dto.studyPreferences,
        };
      }

      if (dto.reminderPreferences) {
        preferences.reminderPreferences = {
          ...preferences.reminderPreferences,
          ...dto.reminderPreferences,
        };
      }

      if (dto.aiPreferences) {
        preferences.aiPreferences = {
          ...preferences.aiPreferences,
          ...dto.aiPreferences,
        };
      }

      if (dto.privacySettings) {
        preferences.privacySettings = {
          ...preferences.privacySettings,
          ...dto.privacySettings,
        };
      }
    }

    const saved = await this.preferenceRepository.save(preferences, userId);
    await this.recalculateProfileCompletion(profile.id);
    return UserPreferenceMapper.toDto(saved);
  }

  private async recalculateProfileCompletion(profileId: string): Promise<void> {
    const profile = await this.profileRepository.findByProfileIdWithRelations(profileId);
    if (profile) {
      const breakdown = this.completionService.calculateCompletion(profile);
      await this.profileRepository.updateCompletionPercentage(
        profileId,
        breakdown.totalPercentage,
      );
    }
  }
}
