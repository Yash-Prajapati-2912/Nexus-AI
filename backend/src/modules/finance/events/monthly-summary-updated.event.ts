export class MonthlySummaryUpdatedEvent {
  constructor(
    public readonly summaryId: string,
    public readonly userId: string,
    public readonly month: number,
    public readonly year: number,
    public readonly totalIncome: number,
    public readonly totalExpenses: number,
    public readonly remainingBudget: number,
  ) {}
}
