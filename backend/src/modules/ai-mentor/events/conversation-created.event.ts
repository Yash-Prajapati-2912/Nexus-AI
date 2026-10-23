import { ConversationType } from '../constants/mentor-enums.constants';

export class ConversationCreatedEvent {
  constructor(
    public readonly conversationId: string,
    public readonly userId: string,
    public readonly title: string,
    public readonly type: ConversationType,
  ) {}
}
