import { SetMetadata, CustomDecorator } from '@nestjs/common';
import { UserRole } from '../enums/user-role.enum';
import { ROLES_KEY } from '../constants/auth.constants';

/**
 * Decorator `@Roles(...roles)`.
 * Enforces role-based access control requirements on controller routes.
 */
export const Roles = (...roles: UserRole[]): CustomDecorator => SetMetadata(ROLES_KEY, roles);
