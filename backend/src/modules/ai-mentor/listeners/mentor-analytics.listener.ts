import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { ConversationCreatedEvent } from '../events/conversation-created.event';

@Injectable()
export class MentorAnalyticsListener {
  private readonly logger = new Logger(MentorAnalyticsListener.name);

  @OnEvent('mentor.conversation_created', { async: true })
  handleConversationCreated(event: ConversationCreatedEvent): Promise<void> {
    this.logger.log(`Mentor Analytics Listener: Conversation ${event.conversationId} (${event.type}) created for user ${event.userId}`);
    return Promise.resolve();
  }
}
