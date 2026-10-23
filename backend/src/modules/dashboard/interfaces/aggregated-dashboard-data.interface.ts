export interface IPlannerOverviewData {
  todaysTasksCount: number;
  completedTasksCount: number;
  taskCompletionPercentage: number;
  upcomingAssignmentsCount: number;
  deadlinesCount: number;
  studyHoursThisWeek: number;
  studyStreakDays: number;
}

export interface IFinanceTransactionOverview {
  id: string;
  title: string;
  amount: number;
  categoryName?: string;
  categoryColour?: string;
  date: string;
  isExpense: boolean;
}

export interface IFinanceOverviewData {
  monthlyBudgetPlanned: number;
  totalSpentMonth: number;
  remainingBudget: number;
  todaysSpending: number;
  savingsProgressPercentage: number;
  financialHealthScore: number;
  totalIncome?: number;
  netBalance?: number;
  aiFinancialTip?: string | null;
  categoryExpenses?: Array<{ label: string; value: number }>;
  activeGoalTitle?: string | null;
  activeGoalTarget?: number;
  activeGoalCurrent?: number;
  recentTransactions?: IFinanceTransactionOverview[];
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
