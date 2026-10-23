import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { QueryFailedError } from 'typeorm';

/**
 * PostgreSQL & TypeORM Database Exception Filter.
 * Catches TypeORM `QueryFailedError` instances and translates native driver error codes
 * into clean HTTP responses:
 *   - Code `23505`: Unique constraint violation -> HTTP 409 Conflict (`ERR_DB_DUPLICATE`)
 *   - Code `23503`: Foreign key constraint violation -> HTTP 400 Bad Request (`ERR_DB_INVALID_FK`)
 *   - Code `23514`: Check constraint violation -> HTTP 400 Bad Request (`ERR_DB_CHECK_FAILED`)
 */
@Catch(QueryFailedError)
export class DatabaseExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(DatabaseExceptionFilter.name);

  catch(exception: QueryFailedError & { code?: string; detail?: string }, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const correlationId = (request as Record<string, any>)['correlationId'] || 'N/A';

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let errorCode = 'ERR_DB_500';
    let message = 'A database operation error occurred.';

    switch (exception.code) {
      case '23505': // Unique Constraint Violation
        status = HttpStatus.CONFLICT;
        errorCode = 'ERR_DB_DUPLICATE';
        message = 'A record with matching unique fields already exists.';
        break;
      case '23503': // Foreign Key Violation
        status = HttpStatus.BAD_REQUEST;
        errorCode = 'ERR_DB_INVALID_FK';
        message = 'Referenced foreign key entity does not exist.';
        break;
      case '23514': // Check Constraint Violation
        status = HttpStatus.BAD_REQUEST;
        errorCode = 'ERR_DB_CHECK_FAILED';
        message = 'Database check constraint evaluation failed.';
        break;
      default:
        message = process.env.NODE_ENV === 'production'
          ? 'An internal database error occurred.'
          : exception.message;
        break;
    }

    this.logger.error(
      `[DatabaseError] ${request.method} ${request.originalUrl} | Code: ${exception.code} | Msg: ${message} | CorrelationID: ${correlationId}`,
      exception.stack,
    );

    response.status(status).json({
      statusCode: status,
      success: false,
      error: {
        code: errorCode,
        message,
        details: process.env.NODE_ENV === 'production' ? undefined : { driverDetail: exception.detail },
      },
      timestamp: new Date().toISOString(),
      correlationId,
    });
  }
}
