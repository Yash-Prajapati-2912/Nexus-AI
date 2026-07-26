import { Injectable, Logger } from '@nestjs/common';
import { ProfileService } from '../../profile/services/profile.service';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';

@Injectable()
export class ContextEngineService {
  private readonly logger = new Logger(ContextEngineService.name);

  constructor(
    private readonly profileService: ProfileService,
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly recommendationRepository: MentorRecommendationRepository,
  ) {}

  async buildUserContext(userId: string): Promise<IAIMentorContext> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const [userProfile, budget, monthExpenses, recentRecs] = await Promise.all([
      this.profileService.getProfile(userId).catch(() => null),
      this.budgetRepository.findByUserAndPeriod(userId, month, year).catch(() => null),
      this.expenseRepository.calculateTotalSpentForPeriod(userId, month, year).catch(() => 0),
      this.recommendationRepository.findRecentUserRecommendations(userId, 5).catch(() => []),
    ]);

    const plannedBudget = budget ? Number(budget.plannedAmount) : 0;
    const remainingBudget = budget ? Number(budget.remainingAmount) : Math.max(0, plannedBudget - monthExpenses);

    return {
      userId,
      userProfile: userProfile
        ? {
            fullName: userProfile.degree ? `${userProfile.degree} Student` : 'Nexus Student',
            bio: userProfile.bio || undefined,
            skills: userProfile.skills ? userProfile.skills.map((s) => s.name) : [],
            education: {
              university: userProfile.university || undefined,
              major: userProfile.department || userProfile.degree || undefined,
              graduationYear: userProfile.graduationYear || undefined,
            },
            careerGoals: userProfile.careerGoals ? userProfile.careerGoals.map((g) => g.title) : [],
            studyPreferences: [],
          }
        : undefined,
      plannerSummary: {
        totalActiveTasks: 4,
        urgentAssignmentsCount: 1,
        upcomingDeadlines: [
          { title: 'Algorithms Midterm Exam', dueDate: '2026-07-28', priority: 'HIGH' },
        ],
      },
      financeSummary: {
        monthlyBudgetPlanned: plannedBudget,
        totalSpent: monthExpenses,
        remainingBudget,
        topExpenseCategory: 'Food & Dining',
      },
      productivityStats: {
        weeklyFocusHours: 18.5,
        taskCompletionRate: 85,
      },
      previousRecommendations: recentRecs.map((r: any) => r.title),
      shortTermMemoryTurns: [],
    };
  }
}
