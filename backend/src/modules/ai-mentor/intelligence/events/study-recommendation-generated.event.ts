export class StudyRecommendationGeneratedEvent {
  constructor(
    public readonly recommendationId: string,
    public readonly userId: string,
    public readonly weakSubjects: string[],
  ) {}
}
