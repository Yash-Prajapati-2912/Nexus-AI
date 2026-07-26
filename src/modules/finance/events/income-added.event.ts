export class IncomeAddedEvent {
  constructor(
    public readonly incomeId: string,
    public readonly userId: string,
    public readonly source: string,
    public readonly amount: number,
    public readonly receivedDate: Date,
  ) {}
}
