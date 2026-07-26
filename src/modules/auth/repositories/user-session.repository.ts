import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserSession } from '../entities/user-session.entity';

/**
 * Custom User Session Repository.
 */
@Injectable()
export class UserSessionRepository extends BaseRepository<UserSession> {
  constructor(
    @InjectRepository(UserSession)
    private readonly sessionRepository: Repository<UserSession>,
  ) {
    super(sessionRepository);
  }

  /**
   * Find active session by ID.
   */
  async findActiveSession(
    sessionId: string,
    entityManager?: EntityManager,
  ): Promise<UserSession | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { id: sessionId, isActive: true },
    });
  }

  /**
   * Terminates specific user session by setting isActive = false and logoutAt = NOW().
   */
  async terminateSession(sessionId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(sessionId, {
      isActive: false,
      logoutAt: new Date(),
    });
  }

  /**
   * Terminates all active sessions for a given user.
   */
  async terminateAllUserSessions(userId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo
      .createQueryBuilder()
      .update(UserSession)
      .set({
        isActive: false,
        logoutAt: new Date(),
      })
      .where('user_id = :userId', { userId })
      .andWhere('is_active = true')
      .execute();
  }

  /**
   * Updates last activity timestamp for an active session.
   */
  async updateLastActivity(sessionId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(sessionId, {
      lastActivityAt: new Date(),
    });
  }
}
