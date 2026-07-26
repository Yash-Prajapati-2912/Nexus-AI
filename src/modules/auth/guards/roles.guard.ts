import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../constants/auth.constants';
import { UserRole } from '../enums/user-role.enum';
import { IUserResponse } from '../types/auth.types';

/**
 * Role-Based Access Control (RBAC) Guard.
 * Evaluates required roles specified via `@Roles(...)` against user roles attached to request.
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest<{ user: IUserResponse }>();

    if (!user || !user.roles) {
      throw new ForbiddenException('Access denied: User roles not found');
    }

    const hasRole = requiredRoles.some((role) => user.roles.includes(role));

    if (!hasRole) {
      throw new ForbiddenException(
        `Forbidden resource: Required role [${requiredRoles.join(', ')}]`,
      );
    }

    return true;
  }
}
