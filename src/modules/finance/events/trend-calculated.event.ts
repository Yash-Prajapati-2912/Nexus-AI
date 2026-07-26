export class TrendCalculatedEvent {
  constructor(
    public readonly userId: string,
    public readonly periodLabel: string,
    public readonly expenseGrowthPercentage: number,
    public readonly savingsGrowthPercentage: number,
  ) {}
}
