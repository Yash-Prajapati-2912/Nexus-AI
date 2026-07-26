import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

/**
 * Cache-Ready Interceptor.
 * Interface placeholder preparing controller routes for Redis cache-control headers.
 * Injects `Cache-Control: private, max-age=300` headers on GET routes.
 */
@Injectable()
export class CacheReadyInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const httpCtx = context.switchToHttp();
    const req = httpCtx.getRequest();
    const res = httpCtx.getResponse();

    return next.handle().pipe(
      tap(() => {
        if (req.method === 'GET' && !res.getHeader('Cache-Control')) {
          res.setHeader('Cache-Control', 'private, max-age=300'); // 5 minutes default cache hint
        }
      }),
    );
  }
}
