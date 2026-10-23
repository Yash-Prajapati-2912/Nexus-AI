import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../services/auth.service';
import { IUserResponse } from '../types/auth.types';

/**
 * Passport Local Email/Password Strategy.
 */
@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy, 'local') {
  constructor(private readonly authService: AuthService) {
    super({
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true,
    });
  }

  async validate(req: any, email: string, password: string): Promise<IUserResponse> {
    const ipAddress = req.ip || req.connection?.remoteAddress || '127.0.0.1';
    const userAgent = req.headers['user-agent'] || '';

    const user = await this.authService.validateUserCredentials(
      email,
      password,
      ipAddress,
      userAgent,
    );

    if (!user) {
      throw new UnauthorizedException('Invalid email or password credentials');
    }

    return user;
  }
}
