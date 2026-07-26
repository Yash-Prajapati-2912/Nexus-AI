import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { PasswordHistoryRepository } from '../repositories/password-history.repository';

/**
 * Enterprise Password History Enforcement Service (OWASP Compliance).
 * Prevents users from reusing their recently used passwords up to configurable depth (default: 5).
 */
@Injectable()
export class PasswordHistoryService {
  private readonly logger = new Logger(PasswordHistoryService.name);
  private readonly maxHistoryLength = 5;

  constructor(private readonly historyRepository: PasswordHistoryRepository) {}

  /**
   * Checks if proposed new plain-text password matches any password hash in user's history.
   */
  async checkPasswordReuse(userId: string, newPasswordPlain: string): Promise<void> {
    const recentHistory = await this.historyRepository.getRecentHistory(
      userId,
      this.maxHistoryLength,
    );

    for (const record of recentHistory) {
      const isMatched = await bcrypt.compare(newPasswordPlain, record.passwordHash);
      if (isMatched) {
        this.logger.warn(`[Password Reuse Blocked] User ID ${userId} attempted to reuse a previous password.`);
        throw new BadRequestException(
          `For security reasons, you cannot reuse any of your last ${this.maxHistoryLength} passwords.`,
        );
      }
    }
  }

  /**
   * Records a new password hash into user's password history and truncates old entries.
   */
  async recordPasswordHash(userId: string, passwordHash: string): Promise<void> {
    await this.historyRepository.save({
      userId,
      passwordHash,
    });
    await this.historyRepository.truncateOldHistory(userId, this.maxHistoryLength);
  }
}
