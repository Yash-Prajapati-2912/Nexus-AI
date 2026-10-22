export interface IAIMentorContext {
  userId: string;
  userProfile?: {
    fullName?: string;
    bio?: string;
    skills?: string[];
    education?: {
      university?: string;
      major?: string;
      graduationYear?: number;
    };
    careerGoals?: string[];
    studyPreferences?: string[];
  };
  plannerSummary?: {
    totalActiveTasks: number;
    urgentAssignmentsCount: number;
    upcomingDeadlines: Array<{
      title: string;
      dueDate: string;
      priority: string;
    }>;
  };
  financeSummary?: {
    monthlyBudgetPlanned: number;
    totalSpent: number;
    remainingBudget: number;
    topExpenseCategory?: string;
  };
  productivityStats?: {
    weeklyFocusHours?: number;
    taskCompletionRate?: number;
  };
  previousRecommendations?: string[];
  shortTermMemoryTurns?: Array<{
    role: string;
    text: string;
  }>;
}
