export class PredictionCompletedEvent {
  constructor(
    public readonly predictionId: string,
    public readonly userId: string,
    public readonly predictedBalance: number,
  ) {}
}
