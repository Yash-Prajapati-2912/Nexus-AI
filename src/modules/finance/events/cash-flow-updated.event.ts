export class CashFlowUpdatedEvent {
  constructor(
    public readonly userId: string,
    public readonly netCashFlow: number,
    public readonly projectedEndBalance: number,
  ) {}
}
