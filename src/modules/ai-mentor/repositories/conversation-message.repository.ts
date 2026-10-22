import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ConversationMessage } from '../entities/conversation-message.entity';

@Injectable()
export class ConversationMessageRepository extends BaseRepository<ConversationMessage> {
  constructor(
    @InjectRepository(ConversationMessage)
    private readonly msgRepo: Repository<ConversationMessage>,
  ) {
    super(msgRepo);
  }

  async findConversationMessages(
    conversationId: string,
    limit: number = 50,
    entityManager?: EntityManager,
  ): Promise<ConversationMessage[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { conversationId },
      order: { createdAt: 'ASC' },
      take: limit,
    });
  }

  async findRecentMessages(
    conversationId: string,
    limit: number = 6,
    entityManager?: EntityManager,
  ): Promise<ConversationMessage[]> {
    const repo = this.getRepo(entityManager);
    const messages = await repo.find({
      where: { conversationId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
    return messages.reverse();
  }
}
