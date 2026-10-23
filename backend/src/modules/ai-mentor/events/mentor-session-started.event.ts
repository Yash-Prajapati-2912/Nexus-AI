export class MentorSessionStartedEvent {
  constructor(
    public readonly sessionId: string,
    public readonly userId: string,
    public readonly provider: string,
  ) {}
}
