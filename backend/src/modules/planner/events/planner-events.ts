export const PLANNER_EVENT_TOKENS = {
  REMINDER_CREATED: 'planner.reminder.created',
  REMINDER_COMPLETED: 'planner.reminder.completed',
  STUDY_SESSION_STARTED: 'planner.study_session.started',
  STUDY_SESSION_ENDED: 'planner.study_session.ended',
  CALENDAR_EVENT_CREATED: 'planner.calendar_event.created',
  MILESTONE_COMPLETED: 'planner.milestone.completed',
  RECURRING_TASK_GENERATED: 'planner.recurring_task.generated',
} as const;

export class ReminderCreatedEvent {
  constructor(
    public readonly reminderId: string,
    public readonly userId: string,
    public readonly remindAt: Date,
  ) {}
}

export class ReminderCompletedEvent {
  constructor(
    public readonly reminderId: string,
    public readonly userId: string,
  ) {}
}

export class StudySessionStartedEvent {
  constructor(
    public readonly sessionId: string,
    public readonly studyPlanId: string,
    public readonly userId: string,
  ) {}
}

export class StudySessionEndedEvent {
  constructor(
    public readonly sessionId: string,
    public readonly studyPlanId: string,
    public readonly userId: string,
    public readonly durationMinutes: number,
  ) {}
}

export class CalendarEventCreatedEvent {
  constructor(
    public readonly eventId: string,
    public readonly userId: string,
    public readonly startTime: Date,
    public readonly endTime: Date,
  ) {}
}

export class MilestoneCompletedEvent {
  constructor(
    public readonly milestoneId: string,
    public readonly userId: string,
  ) {}
}

export class RecurringTaskGeneratedEvent {
  constructor(
    public readonly recurringTaskId: string,
    public readonly generatedTaskId: string,
    public readonly userId: string,
  ) {}
}
