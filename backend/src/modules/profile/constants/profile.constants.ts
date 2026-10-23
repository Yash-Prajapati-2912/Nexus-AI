import { IUserPreferenceStructure } from '../interfaces/user-preference.interface';
import { ThemePreference } from './theme.enum';

/**
 * Profile Module Constants & Default Configuration Weights.
 */
export const PROFILE_COMPLETION_WEIGHTS = {
  BASIC_INFO: 35,
  AVATAR: 10,
  EDUCATION: 15,
  SKILLS: 15,
  CAREER_GOALS: 15,
  PREFERENCES: 10,
} as const;

export const DEFAULT_USER_PREFERENCES: IUserPreferenceStructure = {
  theme: ThemePreference.SYSTEM,
  language: 'en',
  notificationPreferences: {
    email: true,
    push: true,
    sms: false,
    inApp: true,
    frequency: 'IMMEDIATE',
  },
  studyPreferences: {
    preferredTime: 'EVENING',
    dailyGoalHours: 4,
    focusMode: true,
    learningStyle: 'VISUAL',
  },
  reminderPreferences: {
    taskReminders: true,
    examAlerts: true,
    breakReminders: true,
    reminderIntervalMinutes: 30,
  },
  aiPreferences: {
    mentorshipFrequency: 'WEEKLY',
    tone: 'ENCOURAGING',
    recommendationCategories: ['ACADEMIC', 'CAREER', 'SKILLS'],
    autoSuggestions: true,
  },
  privacySettings: {
    isPublicProfile: false,
    showSkills: true,
    showEducation: true,
    showCareerGoals: false,
    allowSearchEngineIndexing: false,
  },
};
