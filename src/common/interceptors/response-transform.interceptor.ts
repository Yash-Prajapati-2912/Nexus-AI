import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface ResponseEnvelope<T> {
  statusCode: number;
  success: boolean;
  data: T;
  meta?: Record<string, unknown>;
  timestamp: string;
}

/**
 * Global Response Transformation Interceptor.
 * Intercepts all successful controller return values and wraps them in a uniform
 * enterprise JSON response envelope (`statusCode`, `success: true`, `data`, `meta`, `timestamp`).
 * Eliminates custom envelope boilerplate in individual controllers.
 */
@Injectable()
export class ResponseTransformInterceptor<T>
  implements NestInterceptor<T, ResponseEnvelope<T>>
{
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ResponseEnvelope<T>> {
    const ctx = context.switchToHttp();
    const response = ctx.getResponse();

    return next.handle().pipe(
      map((result) => {
        // If result already contains paginated meta format, unpack meta object
        const isPaginated =
          result && typeof result === 'object' && 'data' in result && 'meta' in result;

        const dataPayload = isPaginated ? result.data : result;
        const metaPayload = isPaginated ? result.meta : undefined;

        return {
          statusCode: response.statusCode,
          success: true,
          data: dataPayload,
          ...(metaPayload && { meta: metaPayload }),
          timestamp: new Date().toISOString(),
        };
      }),
    );
  }
}
