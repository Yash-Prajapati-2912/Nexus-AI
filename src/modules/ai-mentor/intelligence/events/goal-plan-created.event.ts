export class GoalPlanCreatedEvent {
  constructor(
    public readonly goalPlanId: string,
    public readonly userId: string,
    public readonly goalTitle: string,
    public readonly successProbability: number,
  ) {}
}
