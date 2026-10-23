import { Injectable, Logger, Optional } from '@nestjs/common';
import { ProfileService } from '../../profile/services/profile.service';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { TaskRepository } from '../../planner/repositories/task.repository';
import { AssignmentRepository } from '../../planner/repositories/assignment.repository';
import { TimeTrackingService } from '../../planner/services/time-tracking.service';
import { TaskStatus } from '../../planner/constants/task-status.enum';
import { TaskPriority } from '../../planner/constants/task-priority.enum';
import { AssignmentStatus } from '../../planner/constants/assignment-status.enum';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';

@Injectable()
export class ContextEngineService {
  private readonly logger = new Logger(ContextEngineService.name);

  constructor(
    private readonly profileService: ProfileService,
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly recommendationRepository: MentorRecommendationRepository,
    @Optional() private readonly taskRepository?: TaskRepository,
    @Optional() private readonly assignmentRepository?: AssignmentRepository,
    @Optional() private readonly timeTrackingService?: TimeTrackingService,
  ) {}

  async buildUserContext(userId: string): Promise<IAIMentorContext> {
    const now = new Date();
    const month = now.getUTCMonth() + 1;
    const year = now.getUTCFullYear();

    const [
      userProfile,
      budget,
      monthExpenses,
      recentRecs,
      userTasks,
      userAssignments,
      weeklyTimeTotals,
    ] = await Promise.all([
      this.profileService.getProfile(userId).catch(() => null),
      this.budgetRepository.findByUserAndPeriod(userId, month, year).catch(() => null),
      this.expenseRepository.calculateTotalSpentForPeriod(userId, month, year).catch(() => 0),
      this.recommendationRepository.findRecentUserRecommendations(userId, 5).catch(() => []),
      this.taskRepository
        ? this.taskRepository.findMany({ where: { userId, isArchived: false } as any }).catch(() => [])
        : Promise.resolve([]),
      this.assignmentRepository
        ? this.assignmentRepository.findMany({ where: { userId, isArchived: false } as any }).catch(() => [])
        : Promise.resolve([]),
      this.timeTrackingService
        ? this.timeTrackingService.getAggregatedTotals(userId, 'weekly').catch(() => null)
        : Promise.resolve(null),
    ]);

    const plannedBudget = budget ? Number(budget.plannedAmount) : 0;
    const remainingBudget = budget ? Number(budget.remainingAmount) : Math.max(0, plannedBudget - monthExpenses);

    // Compute Planner Task Metrics
    const activeTasks = (userTasks || []).filter(
      (t: any) => t.status === TaskStatus.TODO || t.status === TaskStatus.IN_PROGRESS,
    );
    const completedTasks = (userTasks || []).filter(
      (t: any) => t.status === TaskStatus.COMPLETED,
    );
    const totalTrackedTasks = activeTasks.length + completedTasks.length;
    const taskCompletionRate =
      totalTrackedTasks > 0 ? Math.round((completedTasks.length / totalTrackedTasks) * 100) : 0;

    // Compute Urgent Items (Assignments and urgent tasks)
    const urgentAssignments = (userAssignments || []).filter(
      (a: any) =>
        a.status !== AssignmentStatus.SUBMITTED &&
        (a.priority === TaskPriority.URGENT ||
          a.priority === TaskPriority.HIGH ||
          (a.deadline && new Date(a.deadline).getTime() < now.getTime())),
    );
    const urgentTasks = activeTasks.filter(
      (t: any) =>
        t.priority === TaskPriority.URGENT ||
        t.priority === TaskPriority.HIGH ||
        (t.dueDate && new Date(t.dueDate).getTime() < now.getTime()),
    );
    const urgentAssignmentsCount =
      (userAssignments && userAssignments.length > 0)
        ? urgentAssignments.length
        : urgentTasks.length;

    // Upcoming Deadlines (combined active tasks + active assignments, sorted by date)
    const upcomingList: Array<{ title: string; dueDate: string; priority: string; timeMs: number }> = [];

    for (const t of activeTasks) {
      if (t.dueDate) {
        const d = new Date(t.dueDate);
        if (!isNaN(d.getTime())) {
          upcomingList.push({
            title: t.title,
            dueDate: d.toISOString().split('T')[0],
            priority: t.priority || TaskPriority.MEDIUM,
            timeMs: d.getTime(),
          });
        }
      }
    }

    for (const a of (userAssignments || [])) {
      if (a.status !== AssignmentStatus.SUBMITTED && a.deadline) {
        const d = new Date(a.deadline);
        if (!isNaN(d.getTime())) {
          upcomingList.push({
            title: a.title,
            dueDate: d.toISOString().split('T')[0],
            priority: a.priority || TaskPriority.HIGH,
            timeMs: d.getTime(),
          });
        }
      }
    }

    upcomingList.sort((a, b) => a.timeMs - b.timeMs);
    const upcomingDeadlines = upcomingList.slice(0, 5).map(({ title, dueDate, priority }) => ({
      title,
      dueDate,
      priority,
    }));

    // Focus hours: real tracked focus time if present in logs, otherwise left undefined (never fabricated)
    const weeklyFocusHours =
      weeklyTimeTotals && weeklyTimeTotals.totalHours > 0
        ? weeklyTimeTotals.totalHours
        : undefined;

    return {
      userId,
      userProfile: userProfile
        ? {
            fullName: userProfile.degree ? `${userProfile.degree} Student` : 'Nexus Student',
            bio: userProfile.bio || undefined,
            skills: userProfile.skills ? userProfile.skills.map((s: any) => s.name) : [],
            education: {
              university: userProfile.university || undefined,
              major: userProfile.department || userProfile.degree || undefined,
              graduationYear: userProfile.graduationYear || undefined,
            },
            careerGoals: userProfile.careerGoals ? userProfile.careerGoals.map((g: any) => g.title) : [],
            studyPreferences: [],
          }
        : undefined,
      plannerSummary: {
        totalActiveTasks: activeTasks.length,
        urgentAssignmentsCount,
        upcomingDeadlines,
      },
      financeSummary: {
        monthlyBudgetPlanned: plannedBudget,
        totalSpent: monthExpenses,
        remainingBudget,
        topExpenseCategory: 'Food & Dining',
      },
      productivityStats: {
        ...(weeklyFocusHours !== undefined ? { weeklyFocusHours } : {}),
        taskCompletionRate,
      },
      previousRecommendations: recentRecs.map((r: any) => r.title),
      shortTermMemoryTurns: [],
    };
  }
}

