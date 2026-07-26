import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  NotFoundException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

/**
 * 404 Route Not Found Exception Filter.
 * Formats unmapped URI path errors into standard RFC 7807 problem details JSON envelopes.
 */
@Catch(NotFoundException)
export class NotFoundExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(NotFoundExceptionFilter.name);

  catch(exception: NotFoundException, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const correlationId = (request as Record<string, any>)['correlationId'] || 'N/A';

    this.logger.warn(`[404 NotFound] ${request.method} ${request.originalUrl} | CorrelationID: ${correlationId}`);

    response.status(HttpStatus.NOT_FOUND).json({
      statusCode: HttpStatus.NOT_FOUND,
      success: false,
      error: {
        code: 'ERR_RES_404',
        message: `The requested URI path '${request.originalUrl}' was not found on this server.`,
      },
      timestamp: new Date().toISOString(),
      correlationId,
    });
  }
}
