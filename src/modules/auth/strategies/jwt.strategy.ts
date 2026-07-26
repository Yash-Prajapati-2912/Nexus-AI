import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { IJwtPayload, IUserResponse } from '../types/auth.types';
import { UserRepository } from '../repositories/user.repository';
import { UserStatus } from '../enums/user-status.enum';
import { AuthMapper } from '../mappers/auth.mapper';

/**
 * Passport JWT Access Token Strategy.
 * Validates bearer access token signature, checks user account active status, and binds user payload to request.
 */
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    configService: ConfigService,
    private readonly userRepository: UserRepository,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey:
        configService.get<string>('jwt.secret') ||
        'dev_secret_jwt_access_token_key_nexus_ai_2026',
    });
  }

  async validate(payload: IJwtPayload): Promise<IUserResponse & { sessionId: string }> {
    const user = await this.userRepository.findById(payload.sub);

    if (!user) {
      throw new UnauthorizedException('User account associated with token no longer exists');
    }

    if (user.status === UserStatus.LOCKED) {
      throw new UnauthorizedException('User account is temporarily locked due to failed login attempts');
    }

    if (user.status === UserStatus.SUSPENDED || user.status === UserStatus.INACTIVE) {
      throw new UnauthorizedException('User account is not active');
    }

    const userResponse = AuthMapper.toUserResponse(user);
    return {
      ...userResponse,
      sessionId: payload.sessionId,
    };
  }
}
