import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import {
  PLANNER_EVENT_TOKENS,
  ReminderCreatedEvent,
  CalendarEventCreatedEvent,
  StudySessionStartedEvent,
} from '../events/planner-events';

@Injectable()
export class PlannerAuditListener {
  private readonly logger = new Logger(PlannerAuditListener.name);

  @OnEvent(PLANNER_EVENT_TOKENS.REMINDER_CREATED, { async: true })
  handleReminderCreated(event: ReminderCreatedEvent): void {
    this.logger.log(
      `Audit Log: Reminder ${event.reminderId} created for user ${event.userId} at ${event.remindAt.toISOString()}`,
    );
  }

  @OnEvent(PLANNER_EVENT_TOKENS.CALENDAR_EVENT_CREATED, { async: true })
  handleCalendarEventCreated(event: CalendarEventCreatedEvent): void {
    this.logger.log(
      `Audit Log: Calendar event ${event.eventId} created for user ${event.userId} (${event.startTime.toISOString()} - ${event.endTime.toISOString()})`,
    );
  }

  @OnEvent(PLANNER_EVENT_TOKENS.STUDY_SESSION_STARTED, { async: true })
  handleStudySessionStarted(event: StudySessionStartedEvent): void {
    this.logger.log(
      `Audit Log: Study session ${event.sessionId} started for study plan ${event.studyPlanId}`,
    );
  }
}
