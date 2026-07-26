export class StudyPlanGeneratedEvent {
  constructor(
    public readonly userId: string,
    public readonly planSummary: string,
  ) {}
}

export class TaskPrioritisedEvent {
  constructor(
    public readonly userId: string,
    public readonly taskCount: number,
  ) {}
}

export class DeadlineRiskDetectedEvent {
  constructor(
    public readonly userId: string,
    public readonly highRiskCount: number,
  ) {}
}

export class WorkloadAnalysedEvent {
  constructor(
    public readonly userId: string,
    public readonly dailyLoadHours: number,
  ) {}
}

export class ProductivityInsightGeneratedEvent {
  constructor(
    public readonly userId: string,
    public readonly focusScore: number,
  ) {}
}
