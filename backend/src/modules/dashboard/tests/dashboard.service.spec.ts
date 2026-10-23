import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { DashboardService } from '../services/dashboard.service';
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
import { DashboardCacheService } from '../services/dashboard-cache.service';
import { DashboardQueueProcessor } from '../queue/dashboard.queue';
import { DomainSource } from '../constants/dashboard-enums.constants';

describe('DashboardService', () => {
  let service: DashboardService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockAgg = { aggregate: jest.fn().mockResolvedValue({}) };
    const mockWidgetGen = { generateWidgetPayload: jest.fn().mockResolvedValue({ widgetType: 'WIDGET', title: 'Widget', data: {} }) };
    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined), invalidateUserDashboard: jest.fn().mockResolvedValue(undefined) };
    const mockQueue = { addDashboardRefreshJob: jest.fn().mockResolvedValue({ jobId: 'job-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const mockRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'id-1', isUnlocked: true, unlockedAt: new Date() })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
      findUserInsights: jest.fn().mockResolvedValue([]),
      findUserTimeline: jest.fn().mockResolvedValue([
        { id: 'act-1', domainSource: DomainSource.PLANNER, title: 'Task Completed', description: 'Finished HW', activityDate: new Date() },
      ]),
      findLatestForUser: jest.fn().mockResolvedValue(null),
      findUserAchievements: jest.fn().mockResolvedValue([]),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DashboardService,
        DashboardBuilder,
        { provide: PlannerOverviewAggregator, useValue: mockAgg },
        { provide: FinanceOverviewAggregator, useValue: mockAgg },
        { provide: ProfileOverviewAggregator, useValue: mockAgg },
        { provide: AIInsightsAggregator, useValue: mockAgg },
        { provide: ActivityTimelineAggregator, useValue: mockAgg },
        { provide: AchievementAggregator, useValue: mockAgg },
        { provide: PlannerWidgetGenerator, useValue: mockWidgetGen },
        { provide: FinanceWidgetGenerator, useValue: mockWidgetGen },
        { provide: ProfileWidgetGenerator, useValue: mockWidgetGen },
        { provide: AIWidgetGenerator, useValue: mockWidgetGen },
        { provide: ProductivityWidgetGenerator, useValue: mockWidgetGen },
        { provide: GoalWidgetGenerator, useValue: mockWidgetGen },
        { provide: DashboardSnapshotRepository, useValue: mockRepo },
        { provide: DashboardWidgetRepository, useValue: mockRepo },
        { provide: DashboardAnalyticsRepository, useValue: mockRepo },
        { provide: UserInsightRepository, useValue: mockRepo },
        { provide: AchievementRepository, useValue: mockRepo },
        { provide: ActivityTimelineRepository, useValue: mockRepo },
        { provide: DashboardCacheService, useValue: mockCache },
        { provide: DashboardQueueProcessor, useValue: mockQueue },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<DashboardService>(DashboardService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return aggregated master dashboard payload', async () => {
    const res = await service.getDashboard(mockUserId);
    expect(res.userId).toBe(mockUserId);
    expect(res.widgets.length).toBe(6);
  });

  it('should refresh dashboard cache and enqueue background job', async () => {
    const res = await service.refreshDashboard(mockUserId);
    expect(res.success).toBe(true);
  });
});
