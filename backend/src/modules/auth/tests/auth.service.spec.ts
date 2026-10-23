import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, UnauthorizedException, ForbiddenException } from '@nestjs/common';
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
import { User } from '../entities/user.entity';

describe('AuthService', () => {
  let authService: AuthService;
  let userRepository: jest.Mocked<Partial<UserRepository>>;
  let verificationTokenRepository: jest.Mocked<Partial<VerificationTokenRepository>>;
  let tokenService: jest.Mocked<Partial<TokenService>>;
  let sessionService: jest.Mocked<Partial<SessionService>>;
  let passwordHistoryService: jest.Mocked<Partial<PasswordHistoryService>>;
  let tokenRevocationService: jest.Mocked<Partial<TokenRevocationService>>;
  let authEventsService: jest.Mocked<Partial<AuthEventsService>>;

  const mockUser: User = {
    id: '11111111-2222-3333-4444-555555555555',
    email: 'test@nexus.edu',
    password: '$2b$12$hashedPasswordPlaceholder',
    firstName: 'Test',
    lastName: 'User',
    isEmailVerified: true,
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

  const mockTokens = {
    accessToken: 'mock_access_token',
    refreshToken: 'mock_refresh_token',
    tokenType: 'Bearer' as const,
    expiresIn: 900,
  };

  const mockSession = {
    id: 'session-uuid-1234',
    userId: mockUser.id,
    loginAt: new Date(),
    logoutAt: null,
    lastActivityAt: new Date(),
    ipAddress: '127.0.0.1',
    platform: 'Windows',
    browser: 'Chrome',
    device: 'Desktop',
    userAgent: 'Mozilla/5.0',
    isActive: true,
    user: mockUser,
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
      create: jest.fn(),
      save: jest.fn(),
      incrementFailedAttempts: jest.fn(),
      resetFailedAttempts: jest.fn(),
    };

    verificationTokenRepository = {
      findValidToken: jest.fn(),
      markAsUsed: jest.fn(),
      invalidateUserTokens: jest.fn(),
      create: jest.fn(),
      save: jest.fn(),
    };

    tokenService = {
      generateTokenPair: jest.fn().mockResolvedValue(mockTokens),
      rotateRefreshToken: jest.fn().mockResolvedValue({
        user: mockUser,
        tokens: mockTokens,
        sessionId: 'session-uuid-1234',
      }),
      revokeRefreshToken: jest.fn().mockResolvedValue(undefined),
      revokeAllUserTokens: jest.fn().mockResolvedValue(undefined),
    };

    sessionService = {
      createSession: jest.fn().mockResolvedValue(mockSession),
      touchSession: jest.fn().mockResolvedValue(undefined),
      terminateSession: jest.fn().mockResolvedValue(undefined),
      terminateAllUserSessions: jest.fn().mockResolvedValue(undefined),
    };

    passwordHistoryService = {
      checkPasswordReuse: jest.fn().mockResolvedValue(undefined),
      recordPasswordHash: jest.fn().mockResolvedValue(undefined),
    };

    tokenRevocationService = {
      revokeAllUserSessionsAndTokens: jest.fn().mockResolvedValue(undefined),
    };

    authEventsService = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UserRepository, useValue: userRepository },
        { provide: VerificationTokenRepository, useValue: verificationTokenRepository },
        { provide: TokenService, useValue: tokenService },
        { provide: SessionService, useValue: sessionService },
        { provide: PasswordHistoryService, useValue: passwordHistoryService },
        { provide: TokenRevocationService, useValue: tokenRevocationService },
        { provide: AuthEventsService, useValue: authEventsService },
      ],
    }).compile();

    authService = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should successfully register a new user and return user payload with token pair', async () => {
      (userRepository.findByEmail as jest.Mock).mockResolvedValue(null);
      (userRepository.create as jest.Mock).mockReturnValue(mockUser);
      (userRepository.save as jest.Mock).mockResolvedValue(mockUser);

      const result = await authService.register({
        email: 'newuser@nexus.edu',
        password: 'Password123!',
        firstName: 'New',
        lastName: 'User',
      });

      expect(userRepository.findByEmail).toHaveBeenCalledWith('newuser@nexus.edu');
      expect(userRepository.save).toHaveBeenCalled();
      expect(result.tokens).toEqual(mockTokens);
      expect(result.user.email).toEqual(mockUser.email);
    });

    it('should throw ConflictException if email already exists', async () => {
      (userRepository.findByEmail as jest.Mock).mockResolvedValue(mockUser);

      await expect(
        authService.register({
          email: 'test@nexus.edu',
          password: 'Password123!',
          firstName: 'Duplicate',
          lastName: 'User',
        }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    it('should successfully authenticate with valid credentials', async () => {
      const hashedPassword = await bcrypt.hash('Password123!', 10);
      const userWithHash = { ...mockUser, password: hashedPassword };

      (userRepository.findByEmailWithPassword as jest.Mock).mockResolvedValue(userWithHash);

      const result = await authService.login({
        email: 'test@nexus.edu',
        password: 'Password123!',
      });

      expect(userRepository.resetFailedAttempts).toHaveBeenCalledWith(mockUser.id);
      expect(result.tokens).toEqual(mockTokens);
      expect(result.user.id).toEqual(mockUser.id);
    });

    it('should throw UnauthorizedException on invalid password', async () => {
      const hashedPassword = await bcrypt.hash('Password123!', 10);
      const userWithHash = { ...mockUser, password: hashedPassword };

      (userRepository.findByEmailWithPassword as jest.Mock).mockResolvedValue(userWithHash);
      (userRepository.incrementFailedAttempts as jest.Mock).mockResolvedValue({
        attempts: 1,
        isLocked: false,
        lockedUntil: null,
      });

      await expect(
        authService.login({
          email: 'test@nexus.edu',
          password: 'WrongPassword!',
        }),
      ).rejects.toThrow(UnauthorizedException);

      expect(userRepository.incrementFailedAttempts).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if account is locked', async () => {
      const lockedUser = {
        ...mockUser,
        status: UserStatus.LOCKED,
        lockedUntil: new Date(Date.now() + 15 * 60 * 1000),
      };

      (userRepository.findByEmailWithPassword as jest.Mock).mockResolvedValue(lockedUser);

      await expect(
        authService.login({
          email: 'test@nexus.edu',
          password: 'Password123!',
        }),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('logout', () => {
    it('should revoke refresh token and terminate session on logout', async () => {
      const result = await authService.logout(mockUser.id, { refreshToken: 'mock_rt' }, 'session-123');

      expect(tokenService.revokeRefreshToken).toHaveBeenCalledWith('mock_rt');
      expect(sessionService.terminateSession).toHaveBeenCalledWith('session-123');
      expect(result).toEqual({ success: true });
    });
  });

  describe('logoutAll', () => {
    it('should revoke all tokens and terminate all sessions', async () => {
      const result = await authService.logoutAll(mockUser.id);

      expect(tokenRevocationService.revokeAllUserSessionsAndTokens).toHaveBeenCalledWith(mockUser.id);
      expect(result).toEqual({ success: true });
    });
  });
});
