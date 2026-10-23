import { HttpException, HttpStatus } from '@nestjs/common';

/**
 * Base Application Domain Exception.
 * Extends NestJS `HttpException` to attach explicit error codes and developer details,
 * allowing domain services to throw rich exceptions cleanly mapped by the Global Exception Filter.
 */
export class ApplicationException extends HttpException {
  public readonly errorCode: string;
  public readonly details: unknown;

  constructor(
    message: string,
    errorCode: string = 'ERR_SYS_001',
    status: HttpStatus = HttpStatus.INTERNAL_SERVER_ERROR,
    details: unknown = null,
  ) {
    super(
      {
        message,
        error: errorCode,
        details,
      },
      status,
    );
    this.errorCode = errorCode;
    this.details = details;
  }
}
