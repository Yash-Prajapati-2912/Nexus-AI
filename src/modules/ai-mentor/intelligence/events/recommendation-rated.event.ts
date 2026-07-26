export class RecommendationRatedEvent {
  constructor(
    public readonly feedbackId: string,
    public readonly userId: string,
    public readonly recommendationId: string,
    public readonly isHelpful: boolean,
    public readonly ratingScore: number,
  ) {}
}
