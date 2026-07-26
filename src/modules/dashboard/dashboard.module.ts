import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileModule } from '../profile/profile.module';
import { PlannerModule } from '../planner/planner.module';
import { FinanceModule } from '../finance/finance.module';
import { AIMentorModule } from '../ai-mentor/ai-mentor.module';

// Database Entities
import { DashboardSnapshot } from './entities/dashboard-snapshot.entity';
import { DashboardWidget } from './entities/dashboard-widget.entity';
import { DashboardPreference } from './entities/dashboard-preference.entity';
import { DashboardAnalytics } from './entities/dashboard-analytics.entity';
import { UserInsight } from './entities/user-insight.entity';
import { Achievement } from './entities/achievement.entity';
import { ActivityTimeline } from './entities/activity-timeline.entity';

// Repositories
import { DashboardSnapshotRepository } from './repositories/dashboard-snapshot.repository';
import { DashboardWidgetRepository } from './repositories/dashboard-widget.repository';
import { DashboardPreferenceRepository } from './repositories/dashboard-preference.repository';
import { DashboardAnalyticsRepository } from './repositories/dashboard-analytics.repository';
import { UserInsightRepository } from './repositories/user-insight.repository';
import { AchievementRepository } from './repositories/achievement.repository';
import { ActivityTimelineRepository } from './repositories/activity-timeline.repository';

// Aggregators
import { PlannerOverviewAggregator } from './aggregators/planner-overview.aggregator';
import { FinanceOverviewAggregator } from './aggregators/finance-overview.aggregator';
import { ProfileOverviewAggregator } from './aggregators/profile-overview.aggregator';
import { AIInsightsAggregator } from './aggregators/ai-insights.aggregator';
import { ActivityTimelineAggregator } from './aggregators/activity-timeline.aggregator';
import { AchievementAggregator } from './aggregators/achievement.aggregator';

// Widget Generators
import { PlannerWidgetGenerator } from './widgets/planner-widget.generator';
import { FinanceWidgetGenerator } from './widgets/finance-widget.generator';
import { ProfileWidgetGenerator } from './widgets/profile-widget.generator';
import { AIWidgetGenerator } from './widgets/ai-widget.generator';
import { ProductivityWidgetGenerator } from './widgets/productivity-widget.generator';
import { GoalWidgetGenerator } from './widgets/goal-widget.generator';

// Builder
import { DashboardBuilder } from './builders/dashboard.builder';

// Queue & Cache & Service
import { DashboardQueueProcessor } from './queue/dashboard.queue';
import { DashboardCacheService } from './services/dashboard-cache.service';
import { DashboardService } from './services/dashboard.service';

// Controller
import { DashboardController } from './controllers/dashboard.controller';

// Event Listeners
import { PlannerEventListener } from './listeners/planner-event.listener';
import { FinanceEventListener } from './listeners/finance-event.listener';
import { MentorEventListener } from './listeners/mentor-event.listener';
import { ProfileEventListener } from './listeners/profile-event.listener';

@Module({
  imports: [
    ProfileModule,
    PlannerModule,
    FinanceModule,
    AIMentorModule,
    TypeOrmModule.forFeature([
      DashboardSnapshot,
      DashboardWidget,
      DashboardPreference,
      DashboardAnalytics,
      UserInsight,
      Achievement,
      ActivityTimeline,
    ]),
  ],
  controllers: [DashboardController],
  providers: [
    // Repositories
    DashboardSnapshotRepository,
    DashboardWidgetRepository,
    DashboardPreferenceRepository,
    DashboardAnalyticsRepository,
    UserInsightRepository,
    AchievementRepository,
    ActivityTimelineRepository,

    // Aggregators
    PlannerOverviewAggregator,
    FinanceOverviewAggregator,
    ProfileOverviewAggregator,
    AIInsightsAggregator,
    ActivityTimelineAggregator,
    AchievementAggregator,

    // Widget Generators (Strategy Pattern)
    PlannerWidgetGenerator,
    FinanceWidgetGenerator,
    ProfileWidgetGenerator,
    AIWidgetGenerator,
    ProductivityWidgetGenerator,
    GoalWidgetGenerator,

    // Builder Pattern
    DashboardBuilder,

    // Queue & Cache & Service
    DashboardQueueProcessor,
    DashboardCacheService,
    DashboardService,

    // Listeners
    PlannerEventListener,
    FinanceEventListener,
    MentorEventListener,
    ProfileEventListener,
  ],
  exports: [
    DashboardService,
    DashboardCacheService,
  ],
})
export class DashboardModule {}
