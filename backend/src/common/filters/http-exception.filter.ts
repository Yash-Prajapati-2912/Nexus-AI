import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

/**
 * Global Enterprise HTTP Exception Filter.
 * Catches all unhandled domain and HTTP exceptions thrown across NestJS controllers.
 * Formats errors into standard RFC 7807 Problem Details envelopes, masks stack traces
 * in production environments, logs error details with correlation IDs, and returns
 * structured JSON error responses to clients.
 */
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const correlationId = (request as Record<string, any>)['correlationId'] || 'N/A';
    const isProduction = process.env.NODE_ENV === 'production';

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let errorCode = 'ERR_SYS_001';
    let errorMessage = 'An unexpected internal server error occurred.';
    let errorDetails: unknown = null;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const resPayload = exception.getResponse();

      if (typeof resPayload === 'object' && resPayload !== null) {
        const payloadObj = resPayload as Record<string, unknown>;
        errorMessage = (payloadObj.message as string) || exception.message;
        errorCode = (payloadObj.error as string) || `ERR_HTTP_${status}`;
        errorDetails = payloadObj.details || null;
      } else {
        errorMessage = resPayload as string;
      }
    } else if (exception instanceof Error) {
      errorMessage = isProduction
        ? 'An unexpected error occurred. Please try again later.'
        : exception.message;
      errorDetails = isProduction ? null : { stack: exception.stack };
    }

    // Log structured error context via Winston
    this.logger.error(
      `[${request.method}] ${request.originalUrl} Status: ${status} | ErrorCode: ${errorCode} | Msg: ${errorMessage} | CorrelationID: ${correlationId}`,
      exception instanceof Error ? exception.stack : undefined,
    );

    const errorBody: Record<string, unknown> = {
      code: errorCode,
      message: errorMessage,
    };
    if (errorDetails) {
      errorBody.details = errorDetails;
    }

    // Send RFC 7807 Problem Details response
    response.status(status).json({
      statusCode: status,
      success: false,
      error: errorBody,
      timestamp: new Date().toISOString(),
      correlationId,
    });
  }
}
