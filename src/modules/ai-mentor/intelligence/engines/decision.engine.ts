import { Injectable, Logger } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

export interface IDecisionAnalysisOutput {
  decisionTitle: string;
  pros: string[];
  cons: string[];
  opportunityCost: string;
  riskAssessment: string;
  longTermImpact: string;
  alternativeSuggestions: string[];
  confidenceScore: number;
}

@Injectable()
export class DecisionEngine {
  private readonly logger = new Logger(DecisionEngine.name);

  analyzeDecision(context: IAIMentorContext, query?: string): IDecisionAnalysisOutput {
    const decisionTitle = query || 'Choosing between Summer Internship vs Research Project';

    return {
      decisionTitle,
      pros: [
        'Gain real-world industry experience and team collaboration skills',
        'Enhance resume for post-graduation placement opportunities',
        'Receive financial stipend or competitive compensation',
      ],
      cons: [
        'Requires 40 hours weekly time commitment during summer period',
        'May temporarily reduce time available for personal side projects',
      ],
      opportunityCost: 'Choosing the internship sacrifices dedicated academic research publication hours, but gains direct industry referral networks.',
      riskAssessment: 'Low to Moderate Risk: Manageable with clear boundary setting and weekly study planning.',
      longTermImpact: 'High positive impact on immediate graduate employment readiness and salary potential.',
      alternativeSuggestions: [
        'Explore part-time summer research collaboration while completing remote internship',
        'Negotiate flexible internship start date to finish preliminary research phase',
      ],
      confidenceScore: 0.92,
    };
  }
}
