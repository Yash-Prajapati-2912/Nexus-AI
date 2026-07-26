import {
  ValidationPipe,
  ValidationPipeOptions,
  BadRequestException,
} from '@nestjs/common';

/**
 * Enterprise Global Validation Pipe Factory.
 * Enforces class-validator annotations across all incoming request DTOs:
 *   - `whitelist: true`: Automatically strips unknown request body parameters.
 *   - `forbidNonWhitelisted: true`: Throws HTTP 400 if unknown parameters are submitted.
 *   - `transform: true`: Automatically transforms payload primitives to DTO class instances.
 *   - Formats field-level validation errors into detailed array payloads.
 */
export function createGlobalValidationPipe(
  options?: ValidationPipeOptions,
): ValidationPipe {
  return new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
    transformOptions: {
      enableImplicitConversion: true,
    },
    exceptionFactory: (errors) => {
      const formattedErrors = errors.map((err) => ({
        field: err.property,
        issues: err.constraints ? Object.values(err.constraints) : [],
      }));

      return new BadRequestException({
        statusCode: 400,
        error: 'ERR_VAL_001',
        message: `Input validation failed for ${formattedErrors.length} field(s).`,
        details: formattedErrors,
      });
    },
    ...options,
  });
}
