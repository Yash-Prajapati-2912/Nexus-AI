import { StudentWellnessScoring } from '../scoring/student-wellness.scoring';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

describe('StudentWellnessScoring', () => {
  let scoring: StudentWellnessScoring;

  beforeEach(() => {
    scoring = new StudentWellnessScoring();
  });

  it('should calculate 7 student wellness and performance scores accurately', () => {
    const mockContext: IAIMentorContext = {
      userId: 'usr-1',
      userProfile: { skills: ['TS', 'Node', 'SQL', 'Docker', 'AWS'] },
      plannerSummary: { totalActiveTasks: 4, urgentAssignmentsCount: 1, upcomingDeadlines: [] },
      financeSummary: { monthlyBudgetPlanned: 1000, totalSpent: 400, remainingBudget: 600 },
      productivityStats: { weeklyFocusHours: 20, taskCompletionRate: 85 },
    };

    const scores = scoring.calculateScores(mockContext);

    expect(scores.goalProgressScore).toBe(78.5);
    expect(scores.careerReadinessScore).toBe(90);
    expect(scores.studyReadinessScore).toBe(85);
    expect(scores.productivityScore).toBe(79.5);
    expect(scores.financialStabilityScore).toBe(60);
    expect(scores.consistencyScore).toBe(82);
    expect(scores.overallStudentWellnessScore).toBeGreaterThan(70);
  });
});
