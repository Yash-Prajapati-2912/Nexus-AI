import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileModule } from '../profile/profile.module';
import { FinanceModule } from '../finance/finance.module';

// Base Entities
import { Conversation } from './entities/conversation.entity';
import { ConversationMessage } from './entities/conversation-message.entity';
import { ConversationContext } from './entities/conversation-context.entity';
import { MentorSession } from './entities/mentor-session.entity';
import { MentorRecommendation } from './entities/mentor-recommendation.entity';
import { MentorFeedback } from './entities/mentor-feedback.entity';
import { AIUsageLog } from './entities/ai-usage-log.entity';

// Intelligence Entities
import { CareerRoadmap } from './intelligence/entities/career-roadmap.entity';
import { StudyRecommendation } from './intelligence/entities/study-recommendation.entity';
import { GoalRecommendation } from './intelligence/entities/goal-recommendation.entity';
import { DecisionAnalysis } from './intelligence/entities/decision-analysis.entity';
import { HabitRecommendation } from './intelligence/entities/habit-recommendation.entity';
import { MentorInsight } from './intelligence/entities/mentor-insight.entity';
import { ActionPlan } from './intelligence/entities/action-plan.entity';
import { RecommendationFeedback } from './intelligence/entities/recommendation-feedback.entity';

// Base Repositories
import { ConversationRepository } from './repositories/conversation.repository';
import { ConversationMessageRepository } from './repositories/conversation-message.repository';
import { ConversationContextRepository } from './repositories/conversation-context.repository';
import { MentorSessionRepository } from './repositories/mentor-session.repository';
import { MentorRecommendationRepository } from './repositories/mentor-recommendation.repository';
import { MentorFeedbackRepository } from './repositories/mentor-feedback.repository';
import { AIUsageLogRepository } from './repositories/ai-usage-log.repository';

// Intelligence Repositories
import { CareerRoadmapRepository } from './intelligence/repositories/career-roadmap.repository';
import { StudyRecommendationRepository } from './intelligence/repositories/study-recommendation.repository';
import { GoalRecommendationRepository } from './intelligence/repositories/goal-recommendation.repository';
import { DecisionAnalysisRepository } from './intelligence/repositories/decision-analysis.repository';
import { HabitRecommendationRepository } from './intelligence/repositories/habit-recommendation.repository';
import { MentorInsightRepository } from './intelligence/repositories/mentor-insight.repository';
import { ActionPlanRepository } from './intelligence/repositories/action-plan.repository';
import { RecommendationFeedbackRepository } from './intelligence/repositories/recommendation-feedback.repository';

// Context & Memory Engine
import { ContextEngineService } from './context/context-engine.service';
import { MentorMemoryEngineService } from './memory/mentor-memory-engine.service';

// Intelligence Specialized Engines & Scoring
import { CareerEngine } from './intelligence/engines/career.engine';
import { StudyEngine } from './intelligence/engines/study.engine';
import { GoalEngine } from './intelligence/engines/goal.engine';
import { DecisionEngine } from './intelligence/engines/decision.engine';
import { HabitCoachingEngine } from './intelligence/engines/habit-coaching.engine';
import { FeedbackLearningEngine } from './intelligence/engines/feedback-learning.engine';
import { StudentWellnessScoring } from './intelligence/scoring/student-wellness.scoring';

// AI Providers & Queue
import { GeminiMentorProvider } from './providers/gemini-mentor.provider';
import { AIMentorProviderFactory } from './providers/ai-mentor-provider.factory';
import { AIMentorQueueProcessor } from './queue/ai-mentor.queue';
import { MentorIntelligenceQueueProcessor } from './intelligence/queue/mentor-intelligence.queue';
import { AIMentorCacheService } from './services/ai-mentor-cache.service';
import { MentorIntelligenceCacheService } from './intelligence/services/mentor-intelligence-cache.service';
import { AIMentorService } from './services/ai-mentor.service';
import { AIMentorIntelligenceService } from './intelligence/services/ai-mentor-intelligence.service';

// Controllers
import { AIMentorController } from './controllers/ai-mentor.controller';
import { AIMentorIntelligenceController } from './intelligence/controllers/ai-mentor-intelligence.controller';

// Event Listeners
import { MentorAnalyticsListener } from './listeners/mentor-analytics.listener';
import { MentorUsageLoggingListener } from './listeners/mentor-usage-logging.listener';
import { MentorDashboardUpdateListener } from './listeners/mentor-dashboard-update.listener';
import { MentorNotificationListener } from './listeners/mentor-notification.listener';
import { IntelligenceAnalyticsListener } from './intelligence/listeners/intelligence-analytics.listener';
import { RecommendationHistoryListener } from './intelligence/listeners/recommendation-history.listener';
import { IntelligenceDashboardListener } from './intelligence/listeners/intelligence-dashboard.listener';
import { IntelligenceNotificationListener } from './intelligence/listeners/intelligence-notification.listener';

@Module({
  imports: [
    ProfileModule,
    FinanceModule,
    TypeOrmModule.forFeature([
      Conversation,
      ConversationMessage,
      ConversationContext,
      MentorSession,
      MentorRecommendation,
      MentorFeedback,
      AIUsageLog,
      CareerRoadmap,
      StudyRecommendation,
      GoalRecommendation,
      DecisionAnalysis,
      HabitRecommendation,
      MentorInsight,
      ActionPlan,
      RecommendationFeedback,
    ]),
  ],
  controllers: [
    AIMentorController,
    AIMentorIntelligenceController,
  ],
  providers: [
    // Base Repositories
    ConversationRepository,
    ConversationMessageRepository,
    ConversationContextRepository,
    MentorSessionRepository,
    MentorRecommendationRepository,
    MentorFeedbackRepository,
    AIUsageLogRepository,

    // Intelligence Repositories
    CareerRoadmapRepository,
    StudyRecommendationRepository,
    GoalRecommendationRepository,
    DecisionAnalysisRepository,
    HabitRecommendationRepository,
    MentorInsightRepository,
    ActionPlanRepository,
    RecommendationFeedbackRepository,

    // Context Engine & Memory
    ContextEngineService,
    MentorMemoryEngineService,

    // Specialized Intelligence Engines
    CareerEngine,
    StudyEngine,
    GoalEngine,
    DecisionEngine,
    HabitCoachingEngine,
    FeedbackLearningEngine,
    StudentWellnessScoring,

    // AI Providers & Infrastructure
    GeminiMentorProvider,
    AIMentorProviderFactory,
    AIMentorQueueProcessor,
    MentorIntelligenceQueueProcessor,
    AIMentorCacheService,
    MentorIntelligenceCacheService,
    AIMentorService,
    AIMentorIntelligenceService,

    // Event Listeners
    MentorAnalyticsListener,
    MentorUsageLoggingListener,
    MentorDashboardUpdateListener,
    MentorNotificationListener,
    IntelligenceAnalyticsListener,
    RecommendationHistoryListener,
    IntelligenceDashboardListener,
    IntelligenceNotificationListener,
  ],
  exports: [
    AIMentorService,
    AIMentorIntelligenceService,
    ContextEngineService,
    GeminiMentorProvider,
    AIMentorProviderFactory,
  ],
})
export class AIMentorModule {}
