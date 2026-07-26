import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request, Response } from 'express';

/**
 * Global HTTP Request Logging Interceptor.
 * Measures API request processing latency in milliseconds and logs incoming HTTP verb,
 * route URI, response status code, and execution duration using Winston.
 * Injects `X-Response-Time-MS` HTTP header into client responses.
 */
@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const ctx = context.switchToHttp();
    const req = ctx.getRequest<Request>();
    const res = ctx.getResponse<Response>();

    const { method, originalUrl } = req;
    const correlationId = (req as Record<string, any>)['correlationId'] || 'N/A';
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const duration = Date.now() - startTime;
        const statusCode = res.statusCode;

        // Inject latency response header
        res.setHeader('X-Response-Time-MS', `${duration}ms`);

        this.logger.log(
          `[${method}] ${originalUrl} ${statusCode} - ${duration}ms | CorrelationID: ${correlationId}`,
        );
      }),
    );
  }
}
