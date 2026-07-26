export class DecisionAnalysisCompletedEvent {
  constructor(
    public readonly decisionId: string,
    public readonly userId: string,
    public readonly decisionTitle: string,
  ) {}
}
