import { Injectable } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

export interface IStudentWellnessScores {
  goalProgressScore: number;
  careerReadinessScore: number;
  studyReadinessScore: number;
  productivityScore: number;
  financialStabilityScore: number;
  consistencyScore: number;
  overallStudentWellnessScore: number;
}

@Injectable()
export class StudentWellnessScoring {
  calculateScores(context: IAIMentorContext): IStudentWellnessScores {
    // 1. Goal Progress Score
    const goalProgressScore = 78.5;

    // 2. Career Readiness Score
    const skillsCount = context.userProfile?.skills?.length || 0;
    const careerReadinessScore = Math.min(95, Math.max(30, 40 + skillsCount * 10));

    // 3. Study Readiness Score
    const taskCount = context.plannerSummary?.totalActiveTasks || 0;
    const urgentCount = context.plannerSummary?.urgentAssignmentsCount || 0;
    const studyReadinessScore = Math.min(100, Math.max(40, 100 - urgentCount * 15 - (taskCount > 8 ? 10 : 0)));

    // 4. Productivity Score
    const focusHours = context.productivityStats?.weeklyFocusHours || 15;
    const completionRate = context.productivityStats?.taskCompletionRate || 80;
    const productivityScore = parseFloat(((completionRate * 0.7) + (Math.min(30, focusHours) / 30 * 30)).toFixed(2));

    // 5. Financial Stability Score
    const planned = context.financeSummary?.monthlyBudgetPlanned || 500;
    const remaining = context.financeSummary?.remainingBudget || 200;
    const financialStabilityScore = planned > 0 ? parseFloat(Math.min(100, Math.max(20, (remaining / planned) * 100)).toFixed(2)) : 70;

    // 6. Consistency Score
    const consistencyScore = 82.0;

    // 7. Overall Student Wellness Score (Weighted Average)
    const overallStudentWellnessScore = parseFloat(
      (
        goalProgressScore * 0.15 +
        careerReadinessScore * 0.15 +
        studyReadinessScore * 0.2 +
        productivityScore * 0.2 +
        financialStabilityScore * 0.15 +
        consistencyScore * 0.15
      ).toFixed(2),
    );

    return {
      goalProgressScore,
      careerReadinessScore,
      studyReadinessScore,
      productivityScore,
      financialStabilityScore,
      consistencyScore,
      overallStudentWellnessScore,
    };
  }
}
