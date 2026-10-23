export interface IMentorRecommendationCard {
  title: string;
  description: string;
  priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  domainCategory?: string;
}

export interface IMentorActionStep {
  step: number;
  title: string;
  description: string;
  targetDeadlineDays?: number;
}

export interface IAIMentorStructuredResponse {
  summary: string;
  reasoning: string[];
  recommendations: IMentorRecommendationCard[];
  actionPlan: IMentorActionStep[];
  confidenceScore: number;
  followUpQuestions: string[];
}
