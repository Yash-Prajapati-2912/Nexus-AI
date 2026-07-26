export class FinancialSummaryGeneratedEvent {
  constructor(
    public readonly analysisId: string,
    public readonly userId: string,
    public readonly providerName: string,
  ) {}
}
