import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as crypto from 'crypto';
import { UserRepository } from '../repositories/user.repository';
import { VerificationTokenRepository } from '../repositories/verification-token.repository';
import { TokenService } from './token.service';
import { SessionService } from './session.service';
import { PasswordHistoryService } from './password-history.service';
import { TokenRevocationService } from './token-revocation.service';
import { AuthEventsService } from './auth-events.service';
import { RegisterDto } from '../dto/register.dto';
import { LoginDto } from '../dto/login.dto';
import { RefreshTokenDto } from '../dto/refresh-token.dto';
import { LogoutDto } from '../dto/logout.dto';
import { ForgotPasswordDto } from '../dto/forgot-password.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { ChangePasswordDto } from '../dto/change-password.dto';
import { VerifyEmailDto } from '../dto/verify-email.dto';
import { ResendVerificationDto } from '../dto/resend-verification.dto';
import { UserStatus } from '../enums/user-status.enum';
import { UserRole } from '../enums/user-role.enum';
import { VerificationTokenType } from '../enums/verification-token-type.enum';
import { AuthMapper } from '../mappers/auth.mapper';
import { IAuthResponse, IUserResponse, IDeviceContext } from '../types/auth.types';
import {
  MAX_FAILED_LOGIN_ATTEMPTS,
  LOCKOUT_DURATION_MS,
} from '../constants/auth.constants';

/**
 * Enterprise Authentication Business Logic Service.
 * Coordinates registration, credential validation, brute-force lockout protection,
 * token issuing/rotation, session management, email verification, password resets, and security events.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly userRepository: UserRepository,
    private readonly verificationTokenRepository: VerificationTokenRepository,
    private readonly tokenService: TokenService,
    private readonly sessionService: SessionService,
    private readonly passwordHistoryService: PasswordHistoryService,
    private readonly tokenRevocationService: TokenRevocationService,
    private readonly authEventsService: AuthEventsService,
  ) {}

  private hashToken(token: string): string {
    return crypto.createHash('sha256').update(token).digest('hex');
  }

  /**
   * Registers a new user account.
   */
  async register(dto: RegisterDto, deviceContext?: IDeviceContext): Promise<IAuthResponse> {
    const existingUser = await this.userRepository.findByEmail(dto.email);
    if (existingUser) {
      this.logger.warn(`[Registration Failed] Attempted duplicate registration for email: ${dto.email}`);
      throw new ConflictException('An account with this email address already exists');
    }

    // Hash password with bcrypt (cost factor 12)
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(dto.password, salt);

    const user = this.userRepository.create({
      email: dto.email,
      password: hashedPassword,
      firstName: dto.firstName,
      lastName: dto.lastName,
      isEmailVerified: process.env.NODE_ENV !== 'production' ? true : false,
      status: UserStatus.ACTIVE,
      roles: [UserRole.STUDENT],
      failedLoginAttempts: 0,
      lockedUntil: null,
      lastLoginAt: new Date(),
    });

    const savedUser = await this.userRepository.save(user);

    // Record initial password history
    await this.passwordHistoryService.recordPasswordHash(savedUser.id, hashedPassword);

    // Create session and issue tokens
    const session = await this.sessionService.createSession(savedUser.id, deviceContext);
    const tokens = await this.tokenService.generateTokenPair(savedUser, session.id, deviceContext);

    // Publish Security Event
    this.authEventsService.emit('auth.user_registered', {
      userId: savedUser.id,
      email: savedUser.email,
      timestamp: new Date().toISOString(),
      ipAddress: deviceContext?.ipAddress,
      userAgent: deviceContext?.userAgent,
    });

    return AuthMapper.toAuthResponse(savedUser, tokens);
  }

  /**
   * Authenticates user credentials with brute-force lockout protection.
   */
  async login(dto: LoginDto, deviceContext?: IDeviceContext): Promise<IAuthResponse> {
    const user = await this.userRepository.findByEmailWithPassword(dto.email);

    if (!user) {
      this.logger.warn(`[Login Failed] Account not found for email: ${dto.email}`);
      this.authEventsService.emit('auth.login_failed', {
        userId: 'unknown',
        email: dto.email,
        attempts: 1,
        timestamp: new Date().toISOString(),
      });
      throw new UnauthorizedException('Invalid email or password credentials');
    }

    // Check account lockout state
    if (user.status === UserStatus.LOCKED && user.lockedUntil) {
      if (new Date() < user.lockedUntil) {
        const remainingMinutes = Math.ceil(
          (user.lockedUntil.getTime() - Date.now()) / (1000 * 60),
        );
        this.logger.warn(`[Login Locked] Attempted login on locked account: ${user.id}`);
        throw new ForbiddenException(
          `Account is temporarily locked due to repeated failed login attempts. Please try again in ${remainingMinutes} minute(s).`,
        );
      } else {
        user.status = UserStatus.ACTIVE;
        user.lockedUntil = null;
        user.failedLoginAttempts = 0;
        await this.userRepository.save(user);
      }
    }

    if (user.status === UserStatus.INACTIVE || user.status === UserStatus.SUSPENDED) {
      this.logger.warn(`[Login Denied] Account status '${user.status}' for user ID: ${user.id}`);
      throw new ForbiddenException('User account is currently inactive or suspended');
    }

    // Compare bcrypt password
    const isPasswordValid = await bcrypt.compare(dto.password, user.password);

    if (!isPasswordValid) {
      const lockResult = await this.userRepository.incrementFailedAttempts(
        user.id,
        LOCKOUT_DURATION_MS,
        MAX_FAILED_LOGIN_ATTEMPTS,
      );

      this.authEventsService.emit('auth.login_failed', {
        userId: user.id,
        email: user.email,
        attempts: lockResult.attempts,
        timestamp: new Date().toISOString(),
      });

      if (lockResult.isLocked) {
        this.authEventsService.emit('auth.account_locked', {
          userId: user.id,
          lockedUntil: lockResult.lockedUntil!,
          timestamp: new Date().toISOString(),
        });
        throw new ForbiddenException(
          `Account locked due to 5 consecutive failed login attempts. Account will remain locked for 15 minutes.`,
        );
      }

      throw new UnauthorizedException('Invalid email or password credentials');
    }

    // Reset failed attempts on successful login
    await this.userRepository.resetFailedAttempts(user.id);

    // Auto-verify email in development mode
    if (process.env.NODE_ENV !== 'production' && !user.isEmailVerified) {
      user.isEmailVerified = true;
      await this.userRepository.save(user);
    }

    // Create session and issue tokens
    const session = await this.sessionService.createSession(user.id, deviceContext);
    const tokens = await this.tokenService.generateTokenPair(user, session.id, deviceContext);

    this.authEventsService.emit('auth.login_succeeded', {
      userId: user.id,
      sessionId: session.id,
      timestamp: new Date().toISOString(),
      ipAddress: deviceContext?.ipAddress,
      userAgent: deviceContext?.userAgent,
    });

    return AuthMapper.toAuthResponse(user, tokens);
  }

  /**
   * Rotates refresh tokens to issue new access & refresh token pair.
   */
  async refreshToken(dto: RefreshTokenDto, deviceContext?: IDeviceContext): Promise<IAuthResponse> {
    const { user, tokens, sessionId } = await this.tokenService.rotateRefreshToken(
      dto.refreshToken,
      deviceContext,
    );

    await this.sessionService.touchSession(sessionId);
    return AuthMapper.toAuthResponse(user, tokens);
  }

  /**
   * Logs out active user session and revokes refresh token.
   */
  async logout(userId: string, dto?: LogoutDto, sessionId?: string): Promise<{ success: boolean }> {
    if (dto?.refreshToken) {
      await this.tokenService.revokeRefreshToken(dto.refreshToken);
    }
    if (sessionId) {
      await this.sessionService.terminateSession(sessionId);
    }
    return { success: true };
  }

  /**
   * Logs out all active user sessions and revokes all refresh tokens across all devices.
   */
  async logoutAll(userId: string): Promise<{ success: boolean }> {
    await this.tokenRevocationService.revokeAllUserSessionsAndTokens(userId);
    return { success: true };
  }

  /**
   * Retrieves sanitized profile payload for current authenticated user.
   */
  async getMe(userId: string): Promise<IUserResponse> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('Authenticated user profile not found');
    }
    if (process.env.NODE_ENV !== 'production' && !user.isEmailVerified) {
      user.isEmailVerified = true;
      await this.userRepository.save(user);
    }
    return AuthMapper.toUserResponse(user);
  }

  /**
   * Verifies user email address using single-use verification token.
   */
  async verifyEmail(dto: VerifyEmailDto): Promise<{ success: boolean; message: string }> {
    const tokenHash = this.hashToken(dto.token);
    const tokenEntity = await this.verificationTokenRepository.findValidToken(
      tokenHash,
      VerificationTokenType.EMAIL_VERIFICATION,
    );

    if (!tokenEntity) {
      throw new BadRequestException('Invalid, expired, or already used email verification token');
    }

    await this.verificationTokenRepository.markAsUsed(tokenEntity.id);
    await this.userRepository.update(tokenEntity.userId, { isEmailVerified: true });

    this.authEventsService.emit('auth.email_verified', {
      userId: tokenEntity.userId,
      email: tokenEntity.user.email,
      timestamp: new Date().toISOString(),
    });

    return {
      success: true,
      message: 'Email address verified successfully.',
    };
  }

  /**
   * Generates and issues a new email verification token.
   */
  async resendVerification(
    dto: ResendVerificationDto,
    deviceContext?: IDeviceContext,
  ): Promise<{ success: boolean; message: string }> {
    const user = await this.userRepository.findByEmail(dto.email);
    if (!user) {
      // Prevent user enumeration by returning standard success message
      return { success: true, message: 'Verification link sent if account exists.' };
    }

    if (user.isEmailVerified) {
      throw new BadRequestException('Email address is already verified');
    }

    // Invalidate existing pending verification tokens for user
    await this.verificationTokenRepository.invalidateUserTokens(
      user.id,
      VerificationTokenType.EMAIL_VERIFICATION,
    );

    const rawToken = crypto.randomBytes(32).toString('hex');
    const tokenHash = this.hashToken(rawToken);
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

    const tokenEntity = this.verificationTokenRepository.create({
      userId: user.id,
      tokenHash,
      type: VerificationTokenType.EMAIL_VERIFICATION,
      expiresAt,
      isUsed: false,
      ipAddress: deviceContext?.ipAddress || null,
    });

    await this.verificationTokenRepository.save(tokenEntity);
    this.logger.log(`[Verification Token Issued] Raw Token for Dev/Testing: ${rawToken}`);

    return {
      success: true,
      message: 'Verification link sent if account exists.',
    };
  }

  /**
   * Initiates forgot password flow (prevents user enumeration).
   */
  async forgotPassword(
    dto: ForgotPasswordDto,
    deviceContext?: IDeviceContext,
  ): Promise<{ success: boolean; message: string }> {
    const user = await this.userRepository.findByEmail(dto.email);
    if (!user) {
      return { success: true, message: 'If email is registered, reset instructions have been sent.' };
    }

    // Invalidate existing reset tokens
    await this.verificationTokenRepository.invalidateUserTokens(
      user.id,
      VerificationTokenType.PASSWORD_RESET,
    );

    const rawToken = crypto.randomBytes(32).toString('hex');
    const tokenHash = this.hashToken(rawToken);
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    const tokenEntity = this.verificationTokenRepository.create({
      userId: user.id,
      tokenHash,
      type: VerificationTokenType.PASSWORD_RESET,
      expiresAt,
      isUsed: false,
      ipAddress: deviceContext?.ipAddress || null,
    });

    await this.verificationTokenRepository.save(tokenEntity);
    this.logger.log(`[Password Reset Token Issued] Raw Token for Dev/Testing: ${rawToken}`);

    return {
      success: true,
      message: 'If email is registered, reset instructions have been sent.',
    };
  }

  /**
   * Resets password using valid reset token and enforces password history rules.
   */
  async resetPassword(
    dto: ResetPasswordDto,
    deviceContext?: IDeviceContext,
  ): Promise<{ success: boolean; message: string }> {
    const tokenHash = this.hashToken(dto.token);
    const tokenEntity = await this.verificationTokenRepository.findValidToken(
      tokenHash,
      VerificationTokenType.PASSWORD_RESET,
    );

    if (!tokenEntity) {
      throw new BadRequestException('Invalid, expired, or already used password reset token');
    }

    // Check password reuse against history
    await this.passwordHistoryService.checkPasswordReuse(tokenEntity.userId, dto.newPassword);

    // Hash new password
    const salt = await bcrypt.genSalt(12);
    const newHashedPassword = await bcrypt.hash(dto.newPassword, salt);

    // Update user password and passwordChangedAt timestamp
    await this.userRepository.update(tokenEntity.userId, {
      password: newHashedPassword,
      passwordChangedAt: new Date(),
    });

    // Record in history and mark token used
    await this.passwordHistoryService.recordPasswordHash(tokenEntity.userId, newHashedPassword);
    await this.verificationTokenRepository.markAsUsed(tokenEntity.id);

    // Invalidate all existing sessions and refresh tokens for security
    await this.tokenRevocationService.revokeAllUserSessionsAndTokens(tokenEntity.userId);

    this.authEventsService.emit('auth.password_reset', {
      userId: tokenEntity.userId,
      timestamp: new Date().toISOString(),
      ipAddress: deviceContext?.ipAddress,
    });

    return {
      success: true,
      message: 'Password reset successfully. All active sessions terminated.',
    };
  }

  /**
   * Changes authenticated user password with current password verification & history enforcement.
   */
  async changePassword(
    userId: string,
    dto: ChangePasswordDto,
    currentSessionId?: string,
  ): Promise<{ success: boolean; message: string }> {
    const user = await this.userRepository.findByEmailWithPassword((await this.userRepository.findById(userId))!.email);
    if (!user) {
      throw new NotFoundException('User account not found');
    }

    const isCurrentValid = await bcrypt.compare(dto.currentPassword, user.password);
    if (!isCurrentValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Check password history reuse
    await this.passwordHistoryService.checkPasswordReuse(userId, dto.newPassword);

    const salt = await bcrypt.genSalt(12);
    const newHashedPassword = await bcrypt.hash(dto.newPassword, salt);

    await this.userRepository.update(userId, {
      password: newHashedPassword,
      passwordChangedAt: new Date(),
    });

    await this.passwordHistoryService.recordPasswordHash(userId, newHashedPassword);

    // Terminate all sessions except current active session if provided
    await this.tokenService.revokeAllUserTokens(userId);
    if (currentSessionId) {
      // Re-initialize current session
    }

    this.authEventsService.emit('auth.password_changed', {
      userId,
      timestamp: new Date().toISOString(),
    });

    return {
      success: true,
      message: 'Password updated successfully.',
    };
  }

  /**
   * Activates user account.
   */
  async activateAccount(userId: string): Promise<{ success: boolean }> {
    await this.userRepository.update(userId, { status: UserStatus.ACTIVE });
    return { success: true };
  }

  /**
   * Deactivates user account and revokes active tokens.
   */
  async deactivateAccount(userId: string): Promise<{ success: boolean }> {
    await this.userRepository.update(userId, { status: UserStatus.INACTIVE });
    await this.tokenRevocationService.revokeAllUserSessionsAndTokens(userId);
    return { success: true };
  }

  /**
   * Helper method used by LocalStrategy to validate credentials.
   */
  async validateUserCredentials(
    email: string,
    pass: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<IUserResponse | null> {
    try {
      const authResult = await this.login({ email, password: pass }, { ipAddress, userAgent });
      return authResult.user;
    } catch {
      return null;
    }
  }
}
