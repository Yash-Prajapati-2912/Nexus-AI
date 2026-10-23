export interface IAIPromptContext {
  userId: string;
  actionType: string;
  tasks?: any[];
  assignments?: any[];
  studyPlans?: any[];
  studySessions?: any[];
  userProfile?: {
    university?: string;
    degree?: string;
    department?: string;
    semester?: number;
    timezone?: string;
  };
  userPreferences?: {
    availableStudyHoursPerDay?: number;
    studyPreferences?: any;
  };
  historicalMetrics?: {
    completionRate?: number;
    averageCompletionTimeMinutes?: number;
    streakDays?: number;
    missedDeadlines?: number;
  };
  additionalNotes?: string;
}
