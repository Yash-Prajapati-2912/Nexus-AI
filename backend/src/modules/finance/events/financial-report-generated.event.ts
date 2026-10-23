export class FinancialReportGeneratedEvent {
  constructor(
    public readonly reportId: string,
    public readonly userId: string,
    public readonly reportType: string,
    public readonly format: string,
  ) {}
}
