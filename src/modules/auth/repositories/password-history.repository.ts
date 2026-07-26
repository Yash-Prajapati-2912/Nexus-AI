import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { PasswordHistory } from '../entities/password-history.entity';

/**
 * Custom Password History Repository.
 */
@Injectable()
export class PasswordHistoryRepository extends BaseRepository<PasswordHistory> {
  constructor(
    @InjectRepository(PasswordHistory)
    private readonly historyRepo: Repository<PasswordHistory>,
  ) {
    super(historyRepo);
  }

  /**
   * Retrieves recent password history entries for a user, ordered by creation date descending.
   */
  async getRecentHistory(
    userId: string,
    limit: number = 5,
    entityManager?: EntityManager,
  ): Promise<PasswordHistory[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }

  /**
   * Truncates old password history entries exceeding the maximum retention limit.
   */
  async truncateOldHistory(
    userId: string,
    maxHistory: number = 5,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    const history = await repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });

    if (history.length > maxHistory) {
      const entriesToRemove = history.slice(maxHistory);
      const idsToRemove = entriesToRemove.map((item) => item.id);
      await repo.delete(idsToRemove);
    }
  }
}
