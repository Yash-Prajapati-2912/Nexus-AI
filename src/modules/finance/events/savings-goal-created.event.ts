export class SavingsGoalCreatedEvent {
  constructor(
    public readonly goalId: string,
    public readonly userId: string,
    public readonly title: string,
    public readonly targetAmount: number,
    public readonly targetDate: Date,
  ) {}
}
