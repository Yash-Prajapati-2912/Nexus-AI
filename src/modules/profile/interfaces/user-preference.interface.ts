import { ThemePreference } from '../constants/theme.enum';

export interface INotificationPreferences {
  email: boolean;
  push: boolean;
  sms: boolean;
  inApp: boolean;
  frequency: 'IMMEDIATE' | 'DAILY_DIGEST' | 'WEEKLY_DIGEST' | 'NEVER';
}

export interface IStudyPreferences {
  preferredTime: 'MORNING' | 'AFTERNOON' | 'EVENING' | 'NIGHT';
  dailyGoalHours: number;
  focusMode: boolean;
  learningStyle: 'VISUAL' | 'AUDITORY' | 'READING_WRITING' | 'KINESTHETIC';
}

export interface IReminderPreferences {
  taskReminders: boolean;
  examAlerts: boolean;
  breakReminders: boolean;
  reminderIntervalMinutes: number;
}

export interface IAiPreferences {
  mentorshipFrequency: 'DAILY' | 'WEEKLY' | 'MONTHLY' | 'ON_DEMAND';
  tone: 'FORMAL' | 'CASUAL' | 'ENCOURAGING' | 'STRICT';
  recommendationCategories: string[];
  autoSuggestions: boolean;
}

export interface IPrivacySettings {
  isPublicProfile: boolean;
  showSkills: boolean;
  showEducation: boolean;
  showCareerGoals: boolean;
  allowSearchEngineIndexing: boolean;
}

export interface IUserPreferenceStructure {
  theme: ThemePreference | string;
  language: string;
  notificationPreferences: INotificationPreferences;
  studyPreferences: IStudyPreferences;
  reminderPreferences: IReminderPreferences;
  aiPreferences: IAiPreferences;
  privacySettings: IPrivacySettings;
}
