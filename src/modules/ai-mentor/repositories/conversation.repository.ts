import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager, ILike } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Conversation } from '../entities/conversation.entity';
import { ConversationType } from '../constants/mentor-enums.constants';

@Injectable()
export class ConversationRepository extends BaseRepository<Conversation> {
  constructor(
    @InjectRepository(Conversation)
    private readonly convRepo: Repository<Conversation>,
  ) {
    super(convRepo);
  }

  async findUserConversations(
    userId: string,
    options?: {
      type?: ConversationType;
      search?: string;
      isArchived?: boolean;
      isPinned?: boolean;
      limit?: number;
      offset?: number;
    },
    entityManager?: EntityManager,
  ): Promise<Conversation[]> {
    const repo = this.getRepo(entityManager);
    const where: any = { userId };

    if (options?.type) where.conversationType = options.type;
    if (options?.isArchived !== undefined) where.isArchived = options.isArchived;
    if (options?.isPinned !== undefined) where.isPinned = options.isPinned;
    if (options?.search) where.title = ILike(`%${options.search}%`);

    return repo.find({
      where,
      order: { isPinned: 'DESC', updatedAt: 'DESC' },
      take: options?.limit || 20,
      skip: options?.offset || 0,
    });
  }
}
