import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';

/**
 * Custom `@Roles('STUDENT', 'ADMIN')` Decorator.
 * Attaches role requirements metadata to controller methods, checked by `RolesGuard`
 * for Role-Based Access Control (RBAC).
 */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
