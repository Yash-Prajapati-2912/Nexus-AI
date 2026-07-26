import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { PlannerOverviewAggregator } from '../aggregators/planner-overview.aggregator';
import { FinanceOverviewAggregator } from '../aggregators/finance-overview.aggregator';
import { ProfileOverviewAggregator } from '../aggregators/profile-overview.aggregator';
import { AIInsightsAggregator } from '../aggregators/ai-insights.aggregator';
import { ActivityTimelineAggregator } from '../aggregators/activity-timeline.aggregator';
import { AchievementAggregator } from '../aggregators/achievement.aggregator';

import { PlannerWidgetGenerator } from '../widgets/planner-widget.generator';
import { FinanceWidgetGenerator } from '../widgets/finance-widget.generator';
import { ProfileWidgetGenerator } from '../widgets/profile-widget.generator';
import { AIWidgetGenerator } from '../widgets/ai-widget.generator';
import { ProductivityWidgetGenerator } from '../widgets/productivity-widget.generator';
import { GoalWidgetGenerator } from '../widgets/goal-widget.generator';

import { DashboardBuilder } from '../builders/dashboard.builder';
import { DashboardSnapshotRepository } from '../repositories/dashboard-snapshot.repository';
import { DashboardWidgetRepository } from '../repositories/dashboard-widget.repository';
import { DashboardAnalyticsRepository } from '../repositories/dashboard-analytics.repository';
import { UserInsightRepository } from '../repositories/user-insight.repository';
import { AchievementRepository } from '../repositories/achievement.repository';
import { ActivityTimelineRepository } from '../repositories/activity-timeline.repository';

import { DashboardCacheService } from './dashboard-cache.service';
import { DashboardQueueProcessor } from '../queue/dashboard.queue';
import { DashboardResponseDto } from '../dto/dashboard-response.dto';
import { ActivityTimelineResponseDto } from '../dto/activity-timeline-response.dto';
import { DashboardAnalyticsResponseDto } from '../dto/dashboard-analytics-response.dto';
import { AchievementResponseDto } from '../dto/achievement-response.dto';
import { UserInsightResponseDto } from '../dto/user-insight-response.dto';
import { DashboardMapper } from '../mappers/dashboard.mapper';
import { DashboardUpdatedEvent } from '../events/dashboard-updated.event';
import { DomainSource } from '../constants/dashboard-enums.constants';

@Injectable()
export class DashboardService {
  private readonly logger = new Logger(DashboardService.name);

  constructor(
    private readonly plannerAggregator: PlannerOverviewAggregator,
    private readonly financeAggregator: FinanceOverviewAggregator,
    private readonly profileAggregator: ProfileOverviewAggregator,
    private readonly aiAggregator: AIInsightsAggregator,
    private readonly activityAggregator: ActivityTimelineAggregator,
    private readonly achievementAggregator: AchievementAggregator,
    private readonly plannerWidgetGen: PlannerWidgetGenerator,
    private readonly financeWidgetGen: FinanceWidgetGenerator,
    private readonly profileWidgetGen: ProfileWidgetGenerator,
    private readonly aiWidgetGen: AIWidgetGenerator,
    private readonly productivityWidgetGen: ProductivityWidgetGenerator,
    private readonly goalWidgetGen: GoalWidgetGenerator,
    private readonly dashboardBuilder: DashboardBuilder,
    private readonly snapshotRepository: DashboardSnapshotRepository,
    private readonly widgetRepository: DashboardWidgetRepository,
    private readonly analyticsRepository: DashboardAnalyticsRepository,
    private readonly insightRepository: UserInsightRepository,
    private readonly achievementRepository: AchievementRepository,
    private readonly activityRepository: ActivityTimelineRepository,
    private readonly cacheService: DashboardCacheService,
    private readonly queueProcessor: DashboardQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getDashboard(userId: string): Promise<DashboardResponseDto> {
    const cacheKey = `dashboard_main_${userId}`;
    const cached = await this.cacheService.get<DashboardResponseDto>(cacheKey);
    if (cached) return cached;

    // Parallel Asynchronous Aggregation
    const [plannerData, financeData, profileData, aiData, activities, achievements, insights] =
      await Promise.all([
        this.plannerAggregator.aggregate(userId),
        this.financeAggregator.aggregate(userId),
        this.profileAggregator.aggregate(userId),
        this.aiAggregator.aggregate(userId),
        this.activityAggregator.aggregate(userId, 10),
        this.achievementAggregator.aggregate(userId),
        this.insightRepository.findUserInsights(userId, 5),
      ]);

    const context = { planner: plannerData, finance: financeData, profile: profileData, ai: aiData };

    // Parallel Widget Payloads Generation (Strategy Pattern)
    const widgets = await Promise.all([
      this.plannerWidgetGen.generateWidgetPayload(userId, context),
      this.financeWidgetGen.generateWidgetPayload(userId, context),
      this.profileWidgetGen.generateWidgetPayload(userId, context),
      this.aiWidgetGen.generateWidgetPayload(userId, context),
      this.productivityWidgetGen.generateWidgetPayload(userId, context),
      this.goalWidgetGen.generateWidgetPayload(userId, context),
    ]);

    // Master Dashboard Assembly (Builder Pattern)
    const dashboard = this.dashboardBuilder
      .setUserId(userId)
      .setPlannerData(plannerData)
      .setFinanceData(financeData)
      .setProfileData(profileData)
      .setAIData(aiData)
      .setWidgets(widgets)
      .setRecentActivities(activities)
      .setAchievements(achievements)
      .setUserInsights(insights)
      .build();

    await this.cacheService.set(cacheKey, dashboard, 300);

    // Save snapshot asynchronously
    const snapshot = this.snapshotRepository.create({ userId, snapshotData: dashboard }, userId);
    await this.snapshotRepository.save(snapshot, userId).catch(() => null);

    return dashboard;
  }

  async getWidgets(userId: string) {
    const dashboard = await this.getDashboard(userId);
    return { widgets: dashboard.widgets };
  }

  async getActivityTimeline(userId: string, limit: number = 20): Promise<ActivityTimelineResponseDto> {
    let activities = await this.activityRepository.findUserTimeline(userId, limit);

    if (activities.length === 0) {
      // Seed default initial activity item
      const initialActivity = this.activityRepository.create(
        {
          userId,
          domainSource: DomainSource.PROFILE,
          title: 'Nexus AI Account Activated',
          description: 'Welcome to Nexus AI Operating System. Account successfully initialized.',
          activityDate: new Date(),
        },
        userId,
      );
      await this.activityRepository.save(initialActivity, userId);
      activities = [initialActivity];
    }

    return {
      activities: activities.map(DashboardMapper.toActivityDto),
      totalCount: activities.length,
    };
  }

  async getAnalytics(userId: string): Promise<DashboardAnalyticsResponseDto> {
    const latest = await this.analyticsRepository.findLatestForUser(userId);

    if (latest) {
      return DashboardMapper.toAnalyticsDto(latest);
    }

    const defaultAnalytics = this.analyticsRepository.create(
      {
        userId,
        focusScore: 82.5,
        productivityScore: 85.0,
        taskCompletionRate: 80.0,
        consistencyScore: 88.0,
        totalStudyHours: 18.5,
        averageDailyStudyHours: 3.7,
      },
      userId,
    );

    const saved = await this.analyticsRepository.save(defaultAnalytics, userId);
    return DashboardMapper.toAnalyticsDto(saved);
  }

  async getAchievements(userId: string): Promise<AchievementResponseDto> {
    const achievements = await this.achievementRepository.findUserAchievements(userId);
    return {
      achievements: achievements.map(DashboardMapper.toAchievementDto),
      unlockedCount: achievements.filter((a) => a.isUnlocked).length,
    };
  }

  async getUserInsights(userId: string): Promise<UserInsightResponseDto> {
    const insights = await this.insightRepository.findUserInsights(userId, 10);
    return {
      insights: insights.map(DashboardMapper.toUserInsightDto),
    };
  }

  async refreshDashboard(userId: string): Promise<{ success: boolean; refreshedAt: Date }> {
    await this.cacheService.invalidateUserDashboard(userId);
    await this.queueProcessor.addDashboardRefreshJob(userId);
    await this.getDashboard(userId);

    this.eventEmitter.emit('dashboard.updated', new DashboardUpdatedEvent(userId));

    return { success: true, refreshedAt: new Date() };
  }
}
