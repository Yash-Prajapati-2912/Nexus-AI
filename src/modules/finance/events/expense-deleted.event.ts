export class ExpenseDeletedEvent {
  constructor(
    public readonly expenseId: string,
    public readonly userId: string,
    public readonly categoryId: string,
    public readonly budgetId: string | null,
    public readonly amount: number,
    public readonly expenseDate: Date,
  ) {}
}
