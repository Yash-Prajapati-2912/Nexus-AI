export class BudgetCreatedEvent {
  constructor(
    public readonly budgetId: string,
    public readonly userId: string,
    public readonly month: number,
    public readonly year: number,
    public readonly plannedAmount: number,
  ) {}
}
