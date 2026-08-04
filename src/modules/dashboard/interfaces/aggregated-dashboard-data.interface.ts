export interface IPlannerOverviewData {
  todaysTasksCount: number;
  completedTasksCount: number;
  taskCompletionPercentage: number;
  upcomingAssignmentsCount: number;
  deadlinesCount: number;
  studyHoursThisWeek: number;
  studyStreakDays: number;
}

export interface IFinanceOverviewData {
  monthlyBudgetPlanned: number;
  totalSpentMonth: number;
  remainingBudget: number;
  todaysSpending: number;
  savingsProgressPercentage: number;
  financialHealthScore: number;
}

export interface IProfileOverviewData {
  fullName: string;
  email?: string;
  avatar?: string | null;
  profileCompletionPercentage: number;
  currentSemester: number | null;
  skillsCount: number;
  careerGoalsCount: number;
  learningProgressPercentage: number;
}

export interface IAIInsightsOverviewData {
  todaysRecommendation: string;
  dailyInsight: string;
  weeklyInsight: string;
  productivityTip: string;
  financialTip: string;
  careerTip: string;
}
