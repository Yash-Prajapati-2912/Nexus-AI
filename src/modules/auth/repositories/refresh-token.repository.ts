import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { RefreshToken } from '../entities/refresh-token.entity';

/**
 * Custom Refresh Token Repository.
 */
@Injectable()
export class RefreshTokenRepository extends BaseRepository<RefreshToken> {
  constructor(
    @InjectRepository(RefreshToken)
    private readonly tokenRepository: Repository<RefreshToken>,
  ) {
    super(tokenRepository);
  }

  /**
   * Find active, non-revoked, non-expired refresh token by token hash.
   */
  async findActiveTokenByHash(
    tokenHash: string,
    entityManager?: EntityManager,
  ): Promise<RefreshToken | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('token')
      .innerJoinAndSelect('token.user', 'user')
      .where('token.token_hash = :tokenHash', { tokenHash })
      .andWhere('token.is_revoked = false')
      .andWhere('token.expires_at > NOW()')
      .andWhere('user.deleted_at IS NULL')
      .getOne();
  }

  /**
   * Revoke specific refresh token string.
   */
  async revokeToken(
    tokenId: string,
    replacedByTokenId?: string,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(tokenId, {
      isRevoked: true,
      revokedAt: new Date(),
      replacedByToken: replacedByTokenId || null,
    });
  }

  /**
   * Revoke all refresh tokens for a user (logout all devices).
   */
  async revokeAllUserTokens(userId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo
      .createQueryBuilder()
      .update(RefreshToken)
      .set({
        isRevoked: true,
        revokedAt: new Date(),
      })
      .where('user_id = :userId', { userId })
      .andWhere('is_revoked = false')
      .execute();
  }
}
