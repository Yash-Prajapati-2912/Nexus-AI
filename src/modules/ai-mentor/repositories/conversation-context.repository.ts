import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ConversationContext } from '../entities/conversation-context.entity';

@Injectable()
export class ConversationContextRepository extends BaseRepository<ConversationContext> {
  constructor(
    @InjectRepository(ConversationContext)
    private readonly ctxRepo: Repository<ConversationContext>,
  ) {
    super(ctxRepo);
  }

  async findLatestForConversation(
    conversationId: string,
    entityManager?: EntityManager,
  ): Promise<ConversationContext | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { conversationId },
      order: { contextVersion: 'DESC' },
    });
  }
}
