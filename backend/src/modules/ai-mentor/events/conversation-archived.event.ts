export class ConversationArchivedEvent {
  constructor(
    public readonly conversationId: string,
    public readonly userId: string,
  ) {}
}
