export class RecommendationGeneratedEvent {
  constructor(
    public readonly recommendationId: string,
    public readonly userId: string,
    public readonly title: string,
    public readonly domainCategory: string,
  ) {}
}
