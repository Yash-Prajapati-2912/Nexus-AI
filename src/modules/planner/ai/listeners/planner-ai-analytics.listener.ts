import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { AI_PLANNER_EVENT_TOKENS } from '../constants/ai-planner.constants';
import {
  StudyPlanGeneratedEvent,
  TaskPrioritisedEvent,
  DeadlineRiskDetectedEvent,
  WorkloadAnalysedEvent,
  ProductivityInsightGeneratedEvent,
} from '../events/planner-ai.events';

@Injectable()
export class PlannerAIAnalyticsListener {
  private readonly logger = new Logger(PlannerAIAnalyticsListener.name);

  @OnEvent(AI_PLANNER_EVENT_TOKENS.STUDY_PLAN_GENERATED, { async: true })
  handleStudyPlanGenerated(event: StudyPlanGeneratedEvent): void {
    this.logger.log(`AI Analytics: Study plan generated for user ${event.userId}`);
  }

  @OnEvent(AI_PLANNER_EVENT_TOKENS.TASK_PRIORITISED, { async: true })
  handleTaskPrioritised(event: TaskPrioritisedEvent): void {
    this.logger.log(`AI Analytics: ${event.taskCount} tasks prioritized for user ${event.userId}`);
  }

  @OnEvent(AI_PLANNER_EVENT_TOKENS.DEADLINE_RISK_DETECTED, { async: true })
  handleDeadlineRiskDetected(event: DeadlineRiskDetectedEvent): void {
    this.logger.log(
      `AI Analytics: Deadline risk detected (${event.highRiskCount} high risk items) for user ${event.userId}`,
    );
  }

  @OnEvent(AI_PLANNER_EVENT_TOKENS.WORKLOAD_ANALYSED, { async: true })
  handleWorkloadAnalysed(event: WorkloadAnalysedEvent): void {
    this.logger.log(
      `AI Analytics: Workload analyzed for user ${event.userId} (Daily load: ${event.dailyLoadHours}h)`,
    );
  }

  @OnEvent(AI_PLANNER_EVENT_TOKENS.PRODUCTIVITY_INSIGHT_GENERATED, { async: true })
  handleProductivityInsight(event: ProductivityInsightGeneratedEvent): void {
    this.logger.log(
      `AI Analytics: Productivity insight generated for user ${event.userId} (Score: ${event.focusScore})`,
    );
  }
}
