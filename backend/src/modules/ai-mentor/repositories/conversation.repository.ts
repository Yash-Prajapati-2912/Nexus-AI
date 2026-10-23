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
      page?: number;
    },
    entityManager?: EntityManager,
  ): Promise<Conversation[]> {
    const repo = this.getRepo(entityManager);
    const where: any = { userId };

    if (options?.type) where.conversationType = options.type;
    if (options?.isArchived !== undefined) where.isArchived = options.isArchived;
    if (options?.isPinned !== undefined) where.isPinned = options.isPinned;
    if (options?.search) where.title = ILike(`%${options.search}%`);

    const limit = options?.limit || 20;
    const offset = options?.offset !== undefined
      ? options.offset
      : (options?.page && options.page > 0 ? (options.page - 1) * limit : 0);

    return repo.find({
      where,
      relations: ['messages'],
      order: { isPinned: 'DESC', updatedAt: 'DESC' },
      take: limit,
      skip: offset,
    });
  }
}
