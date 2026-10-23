import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsObject, IsOptional } from 'class-validator';
import { ThemePreference } from '../constants/theme.enum';
import { IsLanguageCustom } from '../validators/is-language.validator';
import {
  INotificationPreferences,
  IStudyPreferences,
  IReminderPreferences,
  IAiPreferences,
  IPrivacySettings,
} from '../interfaces/user-preference.interface';

export class UpdateUserPreferenceDto {
  @ApiPropertyOptional({
    enum: ThemePreference,
    description: 'UI theme choice',
    example: ThemePreference.DARK,
  })
  @IsOptional()
  @IsEnum(ThemePreference)
  theme?: ThemePreference;

  @ApiPropertyOptional({
    description: 'System display language ISO code',
    example: 'en',
  })
  @IsOptional()
  @IsLanguageCustom()
  language?: string;

  @ApiPropertyOptional({
    description: 'Notification delivery preferences',
    example: {
      email: true,
      push: true,
      sms: false,
      inApp: true,
      frequency: 'IMMEDIATE',
    },
  })
  @IsOptional()
  @IsObject()
  notificationPreferences?: Partial<INotificationPreferences>;

  @ApiPropertyOptional({
    description: 'Personalized study schedule preferences',
    example: {
      preferredTime: 'EVENING',
      dailyGoalHours: 4,
      focusMode: true,
      learningStyle: 'VISUAL',
    },
  })
  @IsOptional()
  @IsObject()
  studyPreferences?: Partial<IStudyPreferences>;

  @ApiPropertyOptional({
    description: 'Reminder and notification alert intervals',
    example: {
      taskReminders: true,
      examAlerts: true,
      breakReminders: true,
      reminderIntervalMinutes: 30,
    },
  })
  @IsOptional()
  @IsObject()
  reminderPreferences?: Partial<IReminderPreferences>;

  @ApiPropertyOptional({
    description: 'AI mentorship and recommendation preferences',
    example: {
      mentorshipFrequency: 'WEEKLY',
      tone: 'ENCOURAGING',
      recommendationCategories: ['ACADEMIC', 'CAREER'],
      autoSuggestions: true,
    },
  })
  @IsOptional()
  @IsObject()
  aiPreferences?: Partial<IAiPreferences>;

  @ApiPropertyOptional({
    description: 'Public profile visibility and privacy controls',
    example: {
      isPublicProfile: true,
      showSkills: true,
      showEducation: true,
      showCareerGoals: false,
      allowSearchEngineIndexing: false,
    },
  })
  @IsOptional()
  @IsObject()
  privacySettings?: Partial<IPrivacySettings>;
}
