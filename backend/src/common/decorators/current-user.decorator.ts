import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * Custom `@CurrentUser()` Parameter Decorator.
 * Extracts the authenticated user identity payload injected into `request.user`
 * by Passport JWT strategies, simplifying controller parameter access.
 */
export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;

    return data ? user?.[data] : user;
  },
);
