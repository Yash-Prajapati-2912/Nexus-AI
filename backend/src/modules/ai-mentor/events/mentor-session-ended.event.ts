export class MentorSessionEndedEvent {
  constructor(
    public readonly sessionId: string,
    public readonly userId: string,
  ) {}
}
