export interface IAIFinancialAnalysisResult {
  summary: string;
  strengths: string[];
  weaknesses: string[];
  recommendations: Array<{
    title: string;
    description: string;
    priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
    category?: string;
    potentialSavings?: number;
  }>;
  warnings: string[];
  confidenceScore: number;
}

export interface IAIMonthEndPredictionResult {
  predictedMonthEndBalance: number;
  expectedTotalSpending: number;
  savingsAchievementProbability: number;
  budgetExhaustionDate: string | null;
  reasoning: string;
  confidenceScore: number;
}

export interface IAISafeDailyBudgetResult {
  safeDailyLimit: number;
  remainingBudget: number;
  remainingDays: number;
  reservedSavings: number;
  plannedUpcomingExpenses: number;
  mathematicalReasoning: string;
  behavioralGuidance: string[];
  confidenceScore: number;
}

export interface IAISavingsPlanResult {
  title: string;
  strategy: string;
  suggestedMonthlyContribution: number;
  targetCategoriesToCut: string[];
  emergencyFundAdvice: string;
  actionSteps: Array<{
    step: number;
    title: string;
    description: string;
  }>;
  confidenceScore: number;
}

export interface IAIExpenseForecastItem {
  title: string;
  categoryName: string;
  forecastedAmount: number;
  forecastDate: string;
  confidence: number;
}

export interface IAIExpenseForecastResult {
  forecastedItems: IAIExpenseForecastItem[];
  totalForecastedAmount: number;
  summary: string;
  confidenceScore: number;
}
