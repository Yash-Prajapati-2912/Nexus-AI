import { Injectable, Logger } from '@nestjs/common';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationMessage } from '../entities/conversation-message.entity';

@Injectable()
export class MentorMemoryEngineService {
  private readonly logger = new Logger(MentorMemoryEngineService.name);

  constructor(private readonly messageRepository: ConversationMessageRepository) {}

  async getShortTermMemory(conversationId: string, turnLimit: number = 6): Promise<Array<{ role: string; text: string }>> {
    const messages: ConversationMessage[] = await this.messageRepository.findConversationMessages(
      conversationId,
      turnLimit,
    );

    return messages.map((m) => ({
      role: m.role,
      text: m.userMessage,
    }));
  }
}
