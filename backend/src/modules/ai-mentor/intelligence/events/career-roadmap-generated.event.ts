export class CareerRoadmapGeneratedEvent {
  constructor(
    public readonly roadmapId: string,
    public readonly userId: string,
    public readonly targetRole: string,
    public readonly readinessScore: number,
  ) {}
}
