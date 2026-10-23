export interface IAIStructuredResponse {
  summary: string;
  reasoning: string[];
  recommendations: Array<{
    title: string;
    description: string;
    priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'URGENT';
    type?: string;
    linkUrl?: string;
  }>;
  actionItems: Array<{
    step: number;
    title: string;
    allocatedMinutes?: number;
    targetDate?: string;
  }>;
  warnings: string[];
  confidenceScore: number; // 0.0 to 1.0
  meta?: Record<string, any>;
}
