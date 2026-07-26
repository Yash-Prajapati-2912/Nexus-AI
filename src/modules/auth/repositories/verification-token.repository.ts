import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { VerificationToken } from '../entities/verification-token.entity';
import { VerificationTokenType } from '../enums/verification-token-type.enum';

/**
 * Custom Verification Token Repository.
 */
@Injectable()
export class VerificationTokenRepository extends BaseRepository<VerificationToken> {
  constructor(
    @InjectRepository(VerificationToken)
    private readonly tokenRepo: Repository<VerificationToken>,
  ) {
    super(tokenRepo);
  }

  /**
   * Find valid, unexpired, unused token by hash and type.
   */
  async findValidToken(
    tokenHash: string,
    type: VerificationTokenType,
    entityManager?: EntityManager,
  ): Promise<VerificationToken | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('vt')
      .innerJoinAndSelect('vt.user', 'user')
      .where('vt.token_hash = :tokenHash', { tokenHash })
      .andWhere('vt.type = :type', { type })
      .andWhere('vt.is_used = false')
      .andWhere('vt.expires_at > NOW()')
      .andWhere('user.deleted_at IS NULL')
      .getOne();
  }

  /**
   * Marks token as used.
   */
  async markAsUsed(tokenId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(tokenId, {
      isUsed: true,
      usedAt: new Date(),
    });
  }

  /**
   * Invalidate all previous pending tokens of a specific type for a user.
   */
  async invalidateUserTokens(
    userId: string,
    type: VerificationTokenType,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo
      .createQueryBuilder()
      .update(VerificationToken)
      .set({ isUsed: true, usedAt: new Date() })
      .where('user_id = :userId', { userId })
      .andWhere('type = :type', { type })
      .andWhere('is_used = false')
      .execute();
  }
}
