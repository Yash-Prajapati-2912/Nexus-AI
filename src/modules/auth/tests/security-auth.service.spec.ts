import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { AuthService } from '../services/auth.service';
import { TokenService } from '../services/token.service';
import { SessionService } from '../services/session.service';
import { PasswordHistoryService } from '../services/password-history.service';
import { TokenRevocationService } from '../services/token-revocation.service';
import { AuthEventsService } from '../services/auth-events.service';
import { UserRepository } from '../repositories/user.repository';
import { VerificationTokenRepository } from '../repositories/verification-token.repository';
import { UserStatus } from '../enums/user-status.enum';
import { UserRole } from '../enums/user-role.enum';
import { VerificationTokenType } from '../enums/verification-token-type.enum';
import { User } from '../entities/user.entity';

describe('SecurityAuthService', () => {
  let authService: AuthService;
  let userRepository: jest.Mocked<Partial<UserRepository>>;
  let verificationTokenRepository: jest.Mocked<Partial<VerificationTokenRepository>>;
  let passwordHistoryService: jest.Mocked<Partial<PasswordHistoryService>>;
  let tokenRevocationService: jest.Mocked<Partial<TokenRevocationService>>;

  const mockUser: User = {
    id: 'user-uuid-1111',
    email: 'alex@nexus.edu',
    password: '$2b$12$hashedPasswordPlaceholder',
    firstName: 'Alex',
    lastName: 'Mercer',
    isEmailVerified: false,
    status: UserStatus.ACTIVE,
    roles: [UserRole.STUDENT],
    lastLoginAt: new Date(),
    failedLoginAttempts: 0,
    lockedUntil: null,
    passwordChangedAt: null,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    createdBy: null,
    updatedBy: null,
    version: 1,
    refreshTokens: [],
    sessions: [],
    isDeleted: () => false,
    setAuditUser: () => {},
  };

  const mockVerificationToken = {
    id: 'token-uuid-9999',
    userId: mockUser.id,
    user: mockUser,
    tokenHash: 'hashed_token',
    type: VerificationTokenType.EMAIL_VERIFICATION,
    expiresAt: new Date(Date.now() + 3600000),
    isUsed: false,
    usedAt: null,
    ipAddress: '127.0.0.1',
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    createdBy: null,
    updatedBy: null,
    version: 1,
    isDeleted: () => false,
    setAuditUser: () => {},
  };

  beforeEach(async () => {
    userRepository = {
      findByEmail: jest.fn(),
      findByEmailWithPassword: jest.fn(),
      findById: jest.fn(),
      update: jest.fn().mockResolvedValue(true),
    };

    verificationTokenRepository = {
      findValidToken: jest.fn(),
      markAsUsed: jest.fn().mockResolvedValue(undefined),
      invalidateUserTokens: jest.fn().mockResolvedValue(undefined),
      create: jest.fn().mockReturnValue(mockVerificationToken),
      save: jest.fn().mockResolvedValue(mockVerificationToken),
    };

    passwordHistoryService = {
      checkPasswordReuse: jest.fn().mockResolvedValue(undefined),
      recordPasswordHash: jest.fn().mockResolvedValue(undefined),
    };

    tokenRevocationService = {
      revokeAllUserSessionsAndTokens: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UserRepository, useValue: userRepository },
        { provide: VerificationTokenRepository, useValue: verificationTokenRepository },
        { provide: TokenService, useValue: { generateTokenPair: jest.fn() } },
        { provide: SessionService, useValue: { createSession: jest.fn() } },
        { provide: PasswordHistoryService, useValue: passwordHistoryService },
        { provide: TokenRevocationService, useValue: tokenRevocationService },
        { provide: AuthEventsService, useValue: { emit: jest.fn() } },
      ],
    }).compile();

    authService = module.get<AuthService>(AuthService);
  });

  describe('verifyEmail', () => {
    it('should successfully verify email with valid token', async () => {
      (verificationTokenRepository.findValidToken as jest.Mock).mockResolvedValue(mockVerificationToken);

      const result = await authService.verifyEmail({ token: 'raw_valid_token' });

      expect(verificationTokenRepository.markAsUsed).toHaveBeenCalledWith(mockVerificationToken.id);
      expect(userRepository.update).toHaveBeenCalledWith(mockUser.id, { isEmailVerified: true });
      expect(result.success).toBe(true);
    });

    it('should throw BadRequestException for invalid or expired token', async () => {
      (verificationTokenRepository.findValidToken as jest.Mock).mockResolvedValue(null);

      await expect(
        authService.verifyEmail({ token: 'invalid_token' }),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('forgotPassword', () => {
    it('should generate reset token if email exists without disclosing account presence', async () => {
      (userRepository.findByEmail as jest.Mock).mockResolvedValue(mockUser);

      const result = await authService.forgotPassword({ email: 'alex@nexus.edu' });

      expect(verificationTokenRepository.invalidateUserTokens).toHaveBeenCalledWith(
        mockUser.id,
        VerificationTokenType.PASSWORD_RESET,
      );
      expect(verificationTokenRepository.save).toHaveBeenCalled();
      expect(result.success).toBe(true);
    });
  });

  describe('resetPassword', () => {
    it('should successfully reset password when valid token is provided', async () => {
      const resetToken = {
        ...mockVerificationToken,
        type: VerificationTokenType.PASSWORD_RESET,
      };
      (verificationTokenRepository.findValidToken as jest.Mock).mockResolvedValue(resetToken);

      const result = await authService.resetPassword({
        token: 'valid_reset_token',
        newPassword: 'NewSecurePassword123!',
      });

      expect(passwordHistoryService.checkPasswordReuse).toHaveBeenCalledWith(
        mockUser.id,
        'NewSecurePassword123!',
      );
      expect(userRepository.update).toHaveBeenCalled();
      expect(tokenRevocationService.revokeAllUserSessionsAndTokens).toHaveBeenCalledWith(mockUser.id);
      expect(result.success).toBe(true);
    });
  });

  describe('activate/deactivate', () => {
    it('should activate user account', async () => {
      const result = await authService.activateAccount(mockUser.id);
      expect(userRepository.update).toHaveBeenCalledWith(mockUser.id, { status: UserStatus.ACTIVE });
      expect(result.success).toBe(true);
    });

    it('should deactivate user account and revoke all sessions', async () => {
      const result = await authService.deactivateAccount(mockUser.id);
      expect(userRepository.update).toHaveBeenCalledWith(mockUser.id, { status: UserStatus.INACTIVE });
      expect(tokenRevocationService.revokeAllUserSessionsAndTokens).toHaveBeenCalledWith(mockUser.id);
      expect(result.success).toBe(true);
    });
  });
});
