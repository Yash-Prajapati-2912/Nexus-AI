import { UserRole } from '../enums/user-role.enum';
import { UserStatus } from '../enums/user-status.enum';

/**
 * JWT Access Token Payload Contract.
 */
export interface IJwtPayload {
  sub: string;
  email: string;
  roles: UserRole[];
  sessionId: string;
  version?: number;
  iat?: number;
  exp?: number;
}

/**
 * JWT Refresh Token Payload Contract.
 */
export interface IJwtRefreshPayload {
  sub: string;
  tokenId: string;
  sessionId: string;
  iat?: number;
  exp?: number;
}

/**
 * Token Pair Response Contract.
 */
export interface ITokenPair {
  accessToken: string;
  refreshToken: string;
  tokenType: 'Bearer';
  expiresIn: number;
}

/**
 * Device & Request Context Info Contract.
 */
export interface IDeviceContext {
  ipAddress: string;
  userAgent: string;
  browser?: string;
  platform?: string;
  device?: string;
}

/**
 * Sanitized User Response Contract.
 */
export interface IUserResponse {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  isEmailVerified: boolean;
  status: UserStatus;
  roles: UserRole[];
  lastLoginAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Auth Token Response Contract.
 */
export interface IAuthResponse {
  user: IUserResponse;
  tokens: ITokenPair;
}
