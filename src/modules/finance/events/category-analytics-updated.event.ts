export class CategoryAnalyticsUpdatedEvent {
  constructor(
    public readonly userId: string,
    public readonly categoryId: string,
    public readonly month: number,
    public readonly year: number,
    public readonly totalSpent: number,
  ) {}
}
