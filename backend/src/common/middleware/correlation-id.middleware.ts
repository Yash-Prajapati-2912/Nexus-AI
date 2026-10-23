import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import * as crypto from 'crypto';

/**
 * Custom Correlation ID Middleware.
 * Injects a unique `X-Correlation-ID` header into every incoming HTTP request
 * if omitted by the client. Attaches the correlation ID to the response header
 * and request context to enable end-to-end distributed tracing across Winston logs.
 */
@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction): void {
    const correlationHeader = req.header('x-correlation-id');
    const correlationId =
      correlationHeader || `req_${Date.now()}_${crypto.randomUUID().substring(0, 8)}`;

    // Set correlation ID on request object for downstream loggers
    (req as Record<string, any>)['correlationId'] = correlationId;

    // Set response header for client tracing
    res.setHeader('X-Correlation-ID', correlationId);

    next();
  }
}
