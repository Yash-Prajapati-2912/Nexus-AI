import { HttpStatus } from '@nestjs/common';
import { ApplicationException } from './application.exception';

/**
 * Domain Business Rule Violation Exception (HTTP 400/422).
 */
export class BusinessException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_BIZ_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.UNPROCESSABLE_ENTITY, details);
  }
}

/**
 * Input Payload Validation Exception (HTTP 400).
 */
export class ValidationException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_VAL_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.BAD_REQUEST, details);
  }
}

/**
 * Resource Not Found Exception (HTTP 404).
 */
export class NotFoundException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_RES_404', details: unknown = null) {
    super(message, errorCode, HttpStatus.NOT_FOUND, details);
  }
}

/**
 * Resource Conflict Exception (HTTP 409).
 */
export class ConflictException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_RES_409', details: unknown = null) {
    super(message, errorCode, HttpStatus.CONFLICT, details);
  }
}

/**
 * Unauthorized Authentication Exception (HTTP 401).
 */
export class UnauthorizedException extends ApplicationException {
  constructor(message = 'Authentication credentials missing or invalid.', errorCode = 'ERR_AUTH_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.UNAUTHORIZED, details);
  }
}

/**
 * Forbidden Access Exception (HTTP 403).
 */
export class ForbiddenException extends ApplicationException {
  constructor(message = 'You do not have required permissions to access this resource.', errorCode = 'ERR_AUTH_004', details: unknown = null) {
    super(message, errorCode, HttpStatus.FORBIDDEN, details);
  }
}

/**
 * External Gateway Service Exception (HTTP 502/503).
 */
export class ThirdPartyException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_EXT_502', details: unknown = null) {
    super(message, errorCode, HttpStatus.BAD_GATEWAY, details);
  }
}

/**
 * PostgreSQL Database Query Failure Exception (HTTP 500/503).
 */
export class DatabaseException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_DB_500', details: unknown = null) {
    super(message, errorCode, HttpStatus.INTERNAL_SERVER_ERROR, details);
  }
}

/**
 * Media Attachment Upload Exception (HTTP 400/413).
 */
export class FileUploadException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_UPL_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.BAD_REQUEST, details);
  }
}

/**
 * Google Gemini Artificial Intelligence Gateway Exception (HTTP 503).
 */
export class AiException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_AI_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.SERVICE_UNAVAILABLE, details);
  }
}

/**
 * Razorpay Payment Gateway & Webhook Exception (HTTP 400/402).
 */
export class PaymentException extends ApplicationException {
  constructor(message: string, errorCode = 'ERR_PAY_001', details: unknown = null) {
    super(message, errorCode, HttpStatus.PAYMENT_REQUIRED, details);
  }
}
