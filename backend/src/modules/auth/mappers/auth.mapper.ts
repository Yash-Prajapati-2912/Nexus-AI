import { User } from '../entities/user.entity';
import { IUserResponse, IAuthResponse, ITokenPair } from '../types/auth.types';

/**
 * Authentication Response Data Mapper.
 * Prevents password hashes or internal database structure leakage.
 */
export class AuthMapper {
  /**
   * Maps User entity to sanitized IUserResponse payload.
   */
  static toUserResponse(user: User): IUserResponse {
    return {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      isEmailVerified: user.isEmailVerified,
      status: user.status,
      roles: user.roles || [],
      lastLoginAt: user.lastLoginAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  /**
   * Maps User entity and generated token pair into complete IAuthResponse envelope.
   */
  static toAuthResponse(user: User, tokens: ITokenPair): IAuthResponse {
    return {
      user: this.toUserResponse(user),
      tokens,
    };
  }
}
