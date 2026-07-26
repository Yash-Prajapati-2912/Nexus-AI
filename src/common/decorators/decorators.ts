import { SetMetadata, createParamDecorator, ExecutionContext } from '@nestjs/common';
import { APP_CONSTANTS } from '../constants';

export const IS_PUBLIC_KEY = 'isPublic';
/**
 * `@Public()` Decorator.
 * Bypasses global JWT authentication guard for unauthenticated public endpoints.
 */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

export const PERMISSIONS_KEY = 'permissions';
/**
 * `@Permissions('read:planner', 'write:planner')` Decorator.
 * Configures fine-grained permission metadata for RBAC guards.
 */
export const Permissions = (...permissions: string[]) => SetMetadata(PERMISSIONS_KEY, permissions);

/**
 * `@Pagination()` Parameter Decorator.
 * Extracts `page` and `limit` query parameters, supplying validated defaults.
 */
export const Pagination = createParamDecorator((data: unknown, ctx: ExecutionContext) => {
  const req = ctx.switchToHttp().getRequest();
  const page = parseInt(req.query.page || APP_CONSTANTS.DEFAULT_PAGE, 10);
  const limit = Math.min(
    parseInt(req.query.limit || APP_CONSTANTS.DEFAULT_LIMIT, 10),
    APP_CONSTANTS.MAX_LIMIT,
  );

  return {
    page: isNaN(page) || page < 1 ? 1 : page,
    limit: isNaN(limit) || limit < 1 ? 20 : limit,
    sort: req.query.sort,
    search: req.query.search,
  };
});

/**
 * `@RequestId()` Parameter Decorator.
 * Extracts correlation request ID from Express request context.
 */
export const RequestId = createParamDecorator((data: unknown, ctx: ExecutionContext) => {
  const req = ctx.switchToHttp().getRequest();
  return req['correlationId'] || 'N/A';
});
