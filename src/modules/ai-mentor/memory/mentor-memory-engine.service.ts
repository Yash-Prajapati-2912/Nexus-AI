import { Injectable, Logger } from '@nestjs/common';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { ConversationMessage } from '../entities/conversation-message.entity';
import { MessageRole } from '../constants/mentor-enums.constants';

@Injectable()
export class MentorMemoryEngineService {
  private readonly logger = new Logger(MentorMemoryEngineService.name);

  constructor(private readonly messageRepository: ConversationMessageRepository) {}

  async getShortTermMemory(
    conversationId: string,
    turnLimit: number = 6,
  ): Promise<Array<{ role: string; text: string }>> {
    const messages: ConversationMessage[] =
      typeof (this.messageRepository as any).findRecentMessages === 'function'
        ? await (this.messageRepository as any).findRecentMessages(conversationId, turnLimit)
        : await this.messageRepository.findConversationMessages(conversationId, turnLimit);

    return messages.map((m) => {
      let text = m.userMessage || '';

      if (m.role === MessageRole.ASSISTANT) {
        const rawAi: any = m.aiResponse;
        if (rawAi && typeof rawAi === 'object') {
          text =
            rawAi.summary ||
            rawAi.content ||
            rawAi.text ||
            (typeof rawAi.response === 'string' ? rawAi.response : '') ||
            m.userMessage ||
            '';
        } else if (typeof rawAi === 'string' && rawAi.trim().length > 0) {
          text = rawAi;
        }
      }

      return {
        role: m.role,
        text,
      };
    });
  }
}
