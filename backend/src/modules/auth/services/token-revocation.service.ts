import { Injectable, Logger } from '@nestjs/common';
import { RefreshTokenRepository } from '../repositories/refresh-token.repository';
import { UserSessionRepository } from '../repositories/user-session.repository';

/**
 * Enterprise Token & Session Revocation Service.
 * Supplies single token revocation, session revocation, global user account revocation,
 * and automated purging of expired tokens.
 */
@Injectable()
export class TokenRevocationService {
  private readonly logger = new Logger(TokenRevocationService.name);

  constructor(
    private readonly refreshTokenRepository: RefreshTokenRepository,
    private readonly userSessionRepository: UserSessionRepository,
  ) {}

  /**
   * Revokes single refresh token by raw token string or ID.
   */
  async revokeSingleToken(rawTokenOrId: string): Promise<void> {
    await this.refreshTokenRepository.revokeToken(rawTokenOrId);
    this.logger.log(`[Token Revoked] Single token revoked.`);
  }

  /**
   * Revokes session and its corresponding refresh tokens.
   */
  async revokeSession(sessionId: string): Promise<void> {
    await this.userSessionRepository.terminateSession(sessionId);
    this.logger.log(`[Session Revoked] Session ID: ${sessionId}`);
  }

  /**
   * Revokes all active refresh tokens and terminates all sessions for a user (Global Revocation).
   */
  async revokeAllUserSessionsAndTokens(userId: string): Promise<void> {
    await this.refreshTokenRepository.revokeAllUserTokens(userId);
    await this.userSessionRepository.terminateAllUserSessions(userId);
    this.logger.log(`[Global Revocation] Revoked all tokens and sessions for user ID: ${userId}`);
  }

  /**
   * Cleans up expired refresh tokens from database.
   */
  async cleanupExpiredTokens(): Promise<number> {
    const result = await this.refreshTokenRepository
      .createQueryBuilder()
      .delete()
      .where('expires_at <= NOW() OR is_revoked = true')
      .execute();

    const affected = result.affected || 0;
    this.logger.log(`[Token Cleanup] Purged ${affected} expired or revoked tokens from database.`);
    return affected;
  }
}
