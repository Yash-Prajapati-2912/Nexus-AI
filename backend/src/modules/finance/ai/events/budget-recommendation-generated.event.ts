export class BudgetRecommendationGeneratedEvent {
  constructor(
    public readonly recommendationId: string,
    public readonly userId: string,
    public readonly title: string,
  ) {}
}
