import { Injectable, Logger } from '@nestjs/common';
import { UserSessionRepository } from '../repositories/user-session.repository';
import { UserSession } from '../entities/user-session.entity';
import { IDeviceContext } from '../types/auth.types';

/**
 * Enterprise User Session Management Service.
 */
@Injectable()
export class SessionService {
  private readonly logger = new Logger(SessionService.name);

  constructor(private readonly sessionRepository: UserSessionRepository) {}

  /**
   * Initializes a new user login session with device analytics.
   */
  async createSession(userId: string, context?: IDeviceContext): Promise<UserSession> {
    const session = this.sessionRepository.create({
      userId,
      loginAt: new Date(),
      lastActivityAt: new Date(),
      isActive: true,
      ipAddress: context?.ipAddress || null,
      userAgent: context?.userAgent || null,
      browser: context?.browser || null,
      platform: context?.platform || null,
      device: context?.device || null,
    });

    const savedSession = await this.sessionRepository.save(session);
    this.logger.log(`[Session Created] User ID: ${userId} | Session ID: ${savedSession.id}`);
    return savedSession;
  }

  /**
   * Updates last activity timestamp for an active session.
   */
  async touchSession(sessionId: string): Promise<void> {
    await this.sessionRepository.updateLastActivity(sessionId);
  }

  /**
   * Terminates a single session.
   */
  async terminateSession(sessionId: string): Promise<void> {
    await this.sessionRepository.terminateSession(sessionId);
    this.logger.log(`[Session Terminated] Session ID: ${sessionId}`);
  }

  /**
   * Terminates all active sessions for a user (logout all devices).
   */
  async terminateAllUserSessions(userId: string): Promise<void> {
    await this.sessionRepository.terminateAllUserSessions(userId);
    this.logger.log(`[All Sessions Terminated] User ID: ${userId}`);
  }
}
