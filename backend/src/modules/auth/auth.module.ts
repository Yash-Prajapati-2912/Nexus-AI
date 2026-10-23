import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';

import { User } from './entities/user.entity';
import { RefreshToken } from './entities/refresh-token.entity';
import { UserSession } from './entities/user-session.entity';
import { VerificationToken } from './entities/verification-token.entity';
import { PasswordHistory } from './entities/password-history.entity';

import { UserRepository } from './repositories/user.repository';
import { RefreshTokenRepository } from './repositories/refresh-token.repository';
import { UserSessionRepository } from './repositories/user-session.repository';
import { VerificationTokenRepository } from './repositories/verification-token.repository';
import { PasswordHistoryRepository } from './repositories/password-history.repository';

import { AuthService } from './services/auth.service';
import { TokenService } from './services/token.service';
import { SessionService } from './services/session.service';
import { PasswordHistoryService } from './services/password-history.service';
import { TokenRevocationService } from './services/token-revocation.service';
import { AuthEventsService } from './services/auth-events.service';

import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { JwtRefreshStrategy } from './strategies/jwt-refresh.strategy';

import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { JwtRefreshGuard } from './guards/jwt-refresh.guard';
import { RolesGuard } from './guards/roles.guard';

import { AuthController } from './controllers/auth.controller';

/**
 * Enterprise Authentication & Security Module.
 * Configures Passport strategies, JWT token issuance, User/Session/RefreshToken/VerificationToken/PasswordHistory persistence,
 * security guards, token revocation, and audit events for Nexus AI.
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([
      User,
      RefreshToken,
      UserSession,
      VerificationToken,
      PasswordHistory,
    ]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        secret:
          configService.get<string>('jwt.secret') ||
          'dev_secret_jwt_access_token_key_nexus_ai_2026',
        signOptions: {
          expiresIn: `${configService.get<number>('jwt.expiresIn') || 900}s`,
        },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [
    UserRepository,
    RefreshTokenRepository,
    UserSessionRepository,
    VerificationTokenRepository,
    PasswordHistoryRepository,
    AuthService,
    TokenService,
    SessionService,
    PasswordHistoryService,
    TokenRevocationService,
    AuthEventsService,
    JwtStrategy,
    LocalStrategy,
    JwtRefreshStrategy,
    JwtAuthGuard,
    LocalAuthGuard,
    JwtRefreshGuard,
    RolesGuard,
  ],
  exports: [
    AuthService,
    TokenService,
    SessionService,
    PasswordHistoryService,
    TokenRevocationService,
    AuthEventsService,
    JwtAuthGuard,
    RolesGuard,
    TypeOrmModule,
  ],
})
export class AuthModule {}
