import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import {
  PLANNER_EVENT_TOKENS,
  StudySessionEndedEvent,
  MilestoneCompletedEvent,
  RecurringTaskGeneratedEvent,
} from '../events/planner-events';

@Injectable()
export class PlannerAnalyticsListener {
  private readonly logger = new Logger(PlannerAnalyticsListener.name);

  @OnEvent(PLANNER_EVENT_TOKENS.STUDY_SESSION_ENDED, { async: true })
  handleStudySessionEnded(event: StudySessionEndedEvent): void {
    this.logger.log(
      `Analytics recorded: Study session ${event.sessionId} ended for user ${event.userId} (Duration: ${event.durationMinutes} mins)`,
    );
  }

  @OnEvent(PLANNER_EVENT_TOKENS.MILESTONE_COMPLETED, { async: true })
  handleMilestoneCompleted(event: MilestoneCompletedEvent): void {
    this.logger.log(
      `Analytics recorded: Milestone ${event.milestoneId} completed for user ${event.userId}`,
    );
  }

  @OnEvent(PLANNER_EVENT_TOKENS.RECURRING_TASK_GENERATED, { async: true })
  handleRecurringTaskGenerated(event: RecurringTaskGeneratedEvent): void {
    this.logger.log(
      `Analytics recorded: Recurring task ${event.recurringTaskId} generated task ${event.generatedTaskId} for user ${event.userId}`,
    );
  }
}
