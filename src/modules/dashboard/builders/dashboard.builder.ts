import { Injectable } from '@nestjs/common';
import {
  IPlannerOverviewData,
  IFinanceOverviewData,
  IProfileOverviewData,
  IAIInsightsOverviewData,
} from '../interfaces/aggregated-dashboard-data.interface';
import { IWidgetPayload } from '../interfaces/widget-generator.interface';
import { ActivityTimeline } from '../entities/activity-timeline.entity';
import { Achievement } from '../entities/achievement.entity';
import { UserInsight } from '../entities/user-insight.entity';
import { DashboardResponseDto } from '../dto/dashboard-response.dto';

@Injectable()
export class DashboardBuilder {
  private userId!: string;
  private plannerData?: IPlannerOverviewData;
  private financeData?: IFinanceOverviewData;
  private profileData?: IProfileOverviewData;
  private aiData?: IAIInsightsOverviewData;
  private widgets: IWidgetPayload[] = [];
  private recentActivities: ActivityTimeline[] = [];
  private achievements: Achievement[] = [];
  private userInsights: UserInsight[] = [];

  setUserId(userId: string): this {
    this.userId = userId;
    return this;
  }

  setPlannerData(data: IPlannerOverviewData): this {
    this.plannerData = data;
    return this;
  }

  setFinanceData(data: IFinanceOverviewData): this {
    this.financeData = data;
    return this;
  }

  setProfileData(data: IProfileOverviewData): this {
    this.profileData = data;
    return this;
  }

  setAIData(data: IAIInsightsOverviewData): this {
    this.aiData = data;
    return this;
  }

  setWidgets(widgets: IWidgetPayload[]): this {
    this.widgets = Array.isArray(widgets) ? widgets : [];
    return this;
  }

  setRecentActivities(activities: ActivityTimeline[]): this {
    this.recentActivities = Array.isArray(activities) ? activities : [];
    return this;
  }

  setAchievements(achievements: Achievement[]): this {
    this.achievements = Array.isArray(achievements) ? achievements : [];
    return this;
  }

  setUserInsights(insights: UserInsight[]): this {
    this.userInsights = Array.isArray(insights) ? insights : [];
    return this;
  }

  build(): DashboardResponseDto {
    return {
      userId: this.userId,
      plannerOverview: this.plannerData || {
        todaysTasksCount: 0,
        completedTasksCount: 0,
        taskCompletionPercentage: 100,
        upcomingAssignmentsCount: 0,
        deadlinesCount: 0,
        studyHoursThisWeek: 0,
        studyStreakDays: 0,
      },
      financeOverview: this.financeData || {
        monthlyBudgetPlanned: 0,
        totalSpentMonth: 0,
        remainingBudget: 0,
        todaysSpending: 0,
        savingsProgressPercentage: 0,
        financialHealthScore: 100,
      },
      profileOverview: this.profileData || {
        fullName: 'Student',
        profileCompletionPercentage: 0,
        currentSemester: null,
        skillsCount: 0,
        careerGoalsCount: 0,
        learningProgressPercentage: 0,
      },
      aiInsightsOverview: this.aiData || {
        todaysRecommendation: '',
        dailyInsight: '',
        weeklyInsight: '',
        productivityTip: '',
        financialTip: '',
        careerTip: '',
      },
      widgets: Array.isArray(this.widgets) ? this.widgets : [],
      recentActivities: (Array.isArray(this.recentActivities) ? this.recentActivities : []).map((act) => ({
        id: act.id,
        domainSource: act.domainSource,
        title: act.title,
        description: act.description,
        activityDate: act.activityDate,
      })),
      achievements: (Array.isArray(this.achievements) ? this.achievements : []).map((ach) => ({
        id: ach.id,
        code: ach.code,
        title: ach.title,
        description: ach.description,
        icon: ach.icon,
        isUnlocked: ach.isUnlocked,
        unlockedAt: ach.unlockedAt,
      })),
      insights: (Array.isArray(this.userInsights) ? this.userInsights : []).map((ins) => ({
        id: ins.id,
        title: ins.title,
        summary: ins.summary,
        detail: ins.detail,
        priorityLevel: ins.priorityLevel,
        domainCategory: ins.domainCategory,
      })),
    };
  }
}
