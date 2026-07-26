import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';
import { IJwtRefreshPayload } from '../types/auth.types';

/**
 * Passport JWT Refresh Token Strategy.
 * Validates refresh token signature and extracts token context from request payload/headers.
 */
@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
  constructor(configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        (req: Request) => {
          if (req?.body?.refreshToken) {
            return req.body.refreshToken;
          }
          return ExtractJwt.fromAuthHeaderAsBearerToken()(req);
        },
      ]),
      ignoreExpiration: false,
      secretOrKey:
        configService.get<string>('jwt.refreshSecret') ||
        'dev_secret_jwt_refresh_token_key_nexus_ai_2026',
      passReqToCallback: true,
    });
  }

  async validate(
    req: Request,
    payload: IJwtRefreshPayload,
  ): Promise<{ userId: string; tokenId: string; sessionId: string; refreshToken: string }> {
    const refreshToken = req?.body?.refreshToken || req.headers.authorization?.replace('Bearer ', '');

    if (!refreshToken) {
      throw new UnauthorizedException('Refresh token is required');
    }

    return {
      userId: payload.sub,
      tokenId: payload.tokenId,
      sessionId: payload.sessionId,
      refreshToken,
    };
  }
}
