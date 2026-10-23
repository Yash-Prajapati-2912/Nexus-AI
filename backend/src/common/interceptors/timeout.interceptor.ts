import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  RequestTimeoutException,
} from '@nestjs/common';
import { Observable, TimeoutError, throwError } from 'rxjs';
import { catchError, timeout } from 'rxjs/operators';

/**
 * Global Request Timeout Interceptor.
 * Enforces a 15-second execution timeout cap across all HTTP controllers.
 * Throws a `RequestTimeoutException` (`HTTP 408`) if request processing exceeds 15,000ms.
 */
@Injectable()
export class TimeoutInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    return next.handle().pipe(
      timeout(15000), // 15 Seconds
      catchError((err) => {
        if (err instanceof TimeoutError) {
          return throwError(
            () =>
              new RequestTimeoutException({
                statusCode: 408,
                error: 'ERR_TIMEOUT_001',
                message: 'Request execution exceeded maximum allowed 15-second SLA boundary.',
              }),
          );
        }
        return throwError(() => err);
      }),
    );
  }
}
