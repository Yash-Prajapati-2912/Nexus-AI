import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * Parameter Decorator `@CurrentSession()`.
 * Extracts active sessionId attached to Request by JwtAuthGuard.
 */
export const CurrentSession = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | null => {
    const request = ctx.switchToHttp().getRequest();
    return request.user?.sessionId || request.sessionId || null;
  },
);
