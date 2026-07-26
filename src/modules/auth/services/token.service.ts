import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import { RefreshTokenRepository } from '../repositories/refresh-token.repository';
import { User } from '../entities/user.entity';
import { RefreshToken } from '../entities/refresh-token.entity';
import { ITokenPair, IJwtPayload, IJwtRefreshPayload, IDeviceContext } from '../types/auth.types';

/**
 * Enterprise Token Management Service.
 * Issues cryptographic access & refresh tokens, hashes refresh tokens before storing in PostgreSQL,
 * executes token rotation, and invalidates compromised token families.
 */
@Injectable()
export class TokenService {
  private readonly logger = new Logger(TokenService.name);
  private readonly accessSecret: string;
  private readonly accessExpiresIn: number;
  private readonly refreshSecret: string;
  private readonly refreshExpiresIn: number;

  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly refreshTokenRepository: RefreshTokenRepository,
  ) {
    this.accessSecret =
      this.configService.get<string>('jwt.secret') ||
      'dev_secret_jwt_access_token_key_nexus_ai_2026';
    this.accessExpiresIn =
      this.configService.get<number>('jwt.expiresIn') || 900; // 15 minutes
    this.refreshSecret =
      this.configService.get<string>('jwt.refreshSecret') ||
      'dev_secret_jwt_refresh_token_key_nexus_ai_2026';
    this.refreshExpiresIn =
      this.configService.get<number>('jwt.refreshExpiresIn') || 604800; // 7 days
  }

  /**
   * Hashes a raw refresh token using SHA-256 for secure storage.
   */
  hashToken(token: string): string {
    return crypto.createHash('sha256').update(token).digest('hex');
  }

  /**
   * Generates a new access token and refresh token pair for a user and session.
   */
  async generateTokenPair(
    user: User,
    sessionId: string,
    deviceContext?: IDeviceContext,
  ): Promise<ITokenPair> {
    const accessPayload: IJwtPayload = {
      sub: user.id,
      email: user.email,
      roles: user.roles || [],
      sessionId,
      version: user.version,
    };

    const accessToken = this.jwtService.sign(accessPayload, {
      secret: this.accessSecret,
      expiresIn: `${this.accessExpiresIn}s`,
    });

    // Create Refresh Token entity placeholder to get UUID
    const expiresAt = new Date(Date.now() + this.refreshExpiresIn * 1000);
    const tokenEntity = this.refreshTokenRepository.create({
      userId: user.id,
      tokenHash: 'pending_hash',
      expiresAt,
      isRevoked: false,
      ipAddress: deviceContext?.ipAddress || null,
      userAgent: deviceContext?.userAgent || null,
      deviceInfo: deviceContext ? `${deviceContext.browser} on ${deviceContext.platform}` : null,
    });

    const savedTokenEntity = await this.refreshTokenRepository.save(tokenEntity);

    const refreshPayload: IJwtRefreshPayload = {
      sub: user.id,
      tokenId: savedTokenEntity.id,
      sessionId,
    };

    const rawRefreshToken = this.jwtService.sign(refreshPayload, {
      secret: this.refreshSecret,
      expiresIn: `${this.refreshExpiresIn}s`,
    });

    // Save actual hashed refresh token
    const tokenHash = this.hashToken(rawRefreshToken);
    await this.refreshTokenRepository.update(savedTokenEntity.id, { tokenHash });

    return {
      accessToken,
      refreshToken: rawRefreshToken,
      tokenType: 'Bearer',
      expiresIn: this.accessExpiresIn,
    };
  }

  /**
   * Rotates an existing refresh token: validates, revokes old token, issues new token pair.
   */
  async rotateRefreshToken(
    rawRefreshToken: string,
    deviceContext?: IDeviceContext,
  ): Promise<{ user: User; tokens: ITokenPair; sessionId: string }> {
    let payload: IJwtRefreshPayload;
    try {
      payload = this.jwtService.verify<IJwtRefreshPayload>(rawRefreshToken, {
        secret: this.refreshSecret,
      });
    } catch {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    const tokenHash = this.hashToken(rawRefreshToken);
    const activeToken = await this.refreshTokenRepository.findActiveTokenByHash(tokenHash);

    if (!activeToken) {
      this.logger.warn(
        `[Security Alert] Attempted reuse of revoked or non-existent refresh token for user ID ${payload.sub}`,
      );
      // Revoke all tokens for safety if revoked token re-used
      await this.refreshTokenRepository.revokeAllUserTokens(payload.sub);
      throw new UnauthorizedException('Refresh token is invalid or has been revoked');
    }

    // Revoke current active token
    await this.refreshTokenRepository.revokeToken(activeToken.id);

    // Issue new token pair
    const tokens = await this.generateTokenPair(activeToken.user, payload.sessionId, deviceContext);

    return {
      user: activeToken.user,
      tokens,
      sessionId: payload.sessionId,
    };
  }

  /**
   * Revokes a specific refresh token by raw token string.
   */
  async revokeRefreshToken(rawRefreshToken: string): Promise<void> {
    const tokenHash = this.hashToken(rawRefreshToken);
    const token = await this.refreshTokenRepository.findOne({ where: { tokenHash } });
    if (token) {
      await this.refreshTokenRepository.revokeToken(token.id);
    }
  }

  /**
   * Revokes all active refresh tokens for a user.
   */
  async revokeAllUserTokens(userId: string): Promise<void> {
    await this.refreshTokenRepository.revokeAllUserTokens(userId);
  }
}
