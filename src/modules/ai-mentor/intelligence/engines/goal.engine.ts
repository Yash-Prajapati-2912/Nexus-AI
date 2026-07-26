import { Injectable, Logger } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

export interface IGoalPlanOutput {
  goalTitle: string;
  decomposedMilestones: Array<{
    step: number;
    title: string;
    description: string;
    estimatedDays: number;
  }>;
  identifiedRisks: string[];
  successProbability: number;
  priorityScore: number;
}

@Injectable()
export class GoalEngine {
  private readonly logger = new Logger(GoalEngine.name);

  decomposeGoal(context: IAIMentorContext, goalTitleQuery?: string): IGoalPlanOutput {
    const goalTitle = goalTitleQuery || context.userProfile?.careerGoals?.[0] || 'Master Advanced Full-Stack Architecture';
    const focusHours = context.productivityStats?.weeklyFocusHours || 15;

    const successProbability = Math.min(95, Math.max(50, focusHours * 4));
    const priorityScore = 85;

    return {
      goalTitle,
      decomposedMilestones: [
        { step: 1, title: 'Foundational Mastery', description: 'Review core concepts and complete documentation exercises', estimatedDays: 7 },
        { step: 2, title: 'Practical Application', description: 'Build mini-project applying target architecture patterns', estimatedDays: 14 },
        { step: 3, title: 'Peer Review & Evaluation', description: 'Refactor code, write unit tests, and perform code review', estimatedDays: 21 },
        { step: 4, title: 'Final Deployment & Showcase', description: 'Deploy live application and publish summary writeup', estimatedDays: 30 },
      ],
      identifiedRisks: [
        'Time allocation conflict with upcoming academic exam deadlines',
        'Scope creep during mid-phase implementation',
      ],
      successProbability: parseFloat(successProbability.toFixed(2)),
      priorityScore,
    };
  }
}
