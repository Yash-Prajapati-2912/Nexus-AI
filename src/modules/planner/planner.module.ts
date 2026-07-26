import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileModule } from '../profile/profile.module';

// Foundation Entities
import { Task } from './entities/task.entity';
import { Assignment } from './entities/assignment.entity';
import { Category } from './entities/category.entity';
import { TaskLabel } from './entities/label.entity';
import { TaskLabelMapping } from './entities/task-label-mapping.entity';

// Advanced Scheduling Entities
import { Reminder } from './entities/reminder.entity';
import { RecurringTask } from './entities/recurring-task.entity';
import { CalendarEvent } from './entities/calendar-event.entity';
import { StudyPlan } from './entities/study-plan.entity';
import { StudySession } from './entities/study-session.entity';
import { Milestone } from './entities/milestone.entity';
import { TaskTimeLog } from './entities/task-time-log.entity';

// AI Planning Entities
import { AIPlanningRequest } from './ai/entities/ai-planning-request.entity';
import { AIPlanningResult } from './ai/entities/ai-planning-result.entity';
import { StudyRecommendation } from './ai/entities/study-recommendation.entity';
import { ProductivityInsight } from './ai/entities/productivity-insight.entity';
import { WorkloadAnalysis } from './ai/entities/workload-analysis.entity';
import { PlannerSuggestion } from './ai/entities/planner-suggestion.entity';
import { AIUsageLog } from './ai/entities/ai-usage-log.entity';

// Repositories
import { TaskRepository } from './repositories/task.repository';
import { AssignmentRepository } from './repositories/assignment.repository';
import { CategoryRepository } from './repositories/category.repository';
import { LabelRepository } from './repositories/label.repository';
import { ReminderRepository } from './repositories/reminder.repository';
import { RecurringTaskRepository } from './repositories/recurring-task.repository';
import { CalendarEventRepository } from './repositories/calendar-event.repository';
import { StudyPlanRepository } from './repositories/study-plan.repository';
import { StudySessionRepository } from './repositories/study-session.repository';
import { MilestoneRepository } from './repositories/milestone.repository';
import { TaskTimeLogRepository } from './repositories/task-time-log.repository';
import { AIPlanningRequestRepository } from './ai/repositories/ai-planning-request.repository';
import { AIPlanningResultRepository } from './ai/repositories/ai-planning-result.repository';
import { AIUsageLogRepository } from './ai/repositories/ai-usage-log.repository';

// Services
import { TaskService } from './services/task.service';
import { AssignmentService } from './services/assignment.service';
import { CategoryService } from './services/category.service';
import { LabelService } from './services/label.service';
import { ReminderService } from './services/reminder.service';
import { RecurringTaskService } from './services/recurring-task.service';
import { CalendarService } from './services/calendar.service';
import { StudyPlanService } from './services/study-plan.service';
import { StudySessionService } from './services/study-session.service';
import { TimeTrackingService } from './services/time-tracking.service';
import { MilestoneService } from './services/milestone.service';
import { ProductivityService } from './services/productivity.service';
import { PlannerAIService } from './ai/services/planner-ai.service';
import { GeminiProvider } from './ai/providers/gemini.provider';
import { AIProviderFactory } from './ai/providers/ai-provider.factory';

// Controllers
import { TaskController } from './controllers/task.controller';
import { AssignmentController } from './controllers/assignment.controller';
import { CategoryController } from './controllers/category.controller';
import { LabelController } from './controllers/label.controller';
import { ReminderController } from './controllers/reminder.controller';
import { RecurringTaskController } from './controllers/recurring-task.controller';
import { CalendarController } from './controllers/calendar.controller';
import { StudyPlanController } from './controllers/study-plan.controller';
import { StudySessionController } from './controllers/study-session.controller';
import { TimeTrackingController } from './controllers/time-tracking.controller';
import { MilestoneController } from './controllers/milestone.controller';
import { ProductivityController } from './controllers/productivity.controller';
import { PlannerAIController } from './ai/controllers/planner-ai.controller';

// Listeners
import { PlannerAnalyticsListener } from './listeners/planner-analytics.listener';
import { PlannerAuditListener } from './listeners/planner-audit.listener';
import { PlannerScheduleListener } from './listeners/planner-schedule.listener';
import { PlannerAIAnalyticsListener } from './ai/listeners/planner-ai-analytics.listener';
import { PlannerAIUsageListener } from './ai/listeners/planner-ai-usage.listener';

@Module({
  imports: [
    ProfileModule,
    TypeOrmModule.forFeature([
      Task,
      Assignment,
      Category,
      TaskLabel,
      TaskLabelMapping,
      Reminder,
      RecurringTask,
      CalendarEvent,
      StudyPlan,
      StudySession,
      Milestone,
      TaskTimeLog,
      AIPlanningRequest,
      AIPlanningResult,
      StudyRecommendation,
      ProductivityInsight,
      WorkloadAnalysis,
      PlannerSuggestion,
      AIUsageLog,
    ]),
  ],
  controllers: [
    TaskController,
    AssignmentController,
    CategoryController,
    LabelController,
    ReminderController,
    RecurringTaskController,
    CalendarController,
    StudyPlanController,
    StudySessionController,
    TimeTrackingController,
    MilestoneController,
    ProductivityController,
    PlannerAIController,
  ],
  providers: [
    // Repositories
    TaskRepository,
    AssignmentRepository,
    CategoryRepository,
    LabelRepository,
    ReminderRepository,
    RecurringTaskRepository,
    CalendarEventRepository,
    StudyPlanRepository,
    StudySessionRepository,
    MilestoneRepository,
    TaskTimeLogRepository,
    AIPlanningRequestRepository,
    AIPlanningResultRepository,
    AIUsageLogRepository,

    // Services & Providers
    TaskService,
    AssignmentService,
    CategoryService,
    LabelService,
    ReminderService,
    RecurringTaskService,
    CalendarService,
    StudyPlanService,
    StudySessionService,
    TimeTrackingService,
    MilestoneService,
    ProductivityService,
    GeminiProvider,
    AIProviderFactory,
    PlannerAIService,

    // Listeners
    PlannerAnalyticsListener,
    PlannerAuditListener,
    PlannerScheduleListener,
    PlannerAIAnalyticsListener,
    PlannerAIUsageListener,
  ],
  exports: [
    TaskService,
    AssignmentService,
    CategoryService,
    LabelService,
    ReminderService,
    RecurringTaskService,
    CalendarService,
    StudyPlanService,
    StudySessionService,
    TimeTrackingService,
    MilestoneService,
    ProductivityService,
    PlannerAIService,
    TaskRepository,
    AssignmentRepository,
  ],
})
export class PlannerModule {}
