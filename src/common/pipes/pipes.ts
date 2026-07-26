import { Injectable, PipeTransform, ArgumentMetadata, BadRequestException } from '@nestjs/common';
import { REGEX_PATTERNS } from '../constants';

/**
 * Trim Strings Pipe.
 * Recursively strips leading and trailing whitespace from string request payload properties.
 */
@Injectable()
export class TrimStringsPipe implements PipeTransform {
  transform(value: unknown, metadata: ArgumentMetadata): unknown {
    if (typeof value === 'string') {
      return value.trim();
    }
    if (typeof value === 'object' && value !== null) {
      return this.trimObject(value as Record<string, unknown>);
    }
    return value;
  }

  private trimObject(obj: Record<string, unknown>): Record<string, unknown> {
    for (const key of Object.keys(obj)) {
      if (typeof obj[key] === 'string') {
        obj[key] = (obj[key] as string).trim();
      } else if (typeof obj[key] === 'object' && obj[key] !== null) {
        obj[key] = this.trimObject(obj[key] as Record<string, unknown>);
      }
    }
    return obj;
  }
}

/**
 * Strict UUID v4 Path Parameter Validation Pipe.
 * Throws HTTP 400 if path parameter is not a valid UUID v4 format.
 */
@Injectable()
export class UuidValidationPipe implements PipeTransform<string> {
  transform(value: string, metadata: ArgumentMetadata): string {
    if (!value || !REGEX_PATTERNS.UUID_V4.test(value)) {
      throw new BadRequestException({
        statusCode: 400,
        error: 'ERR_VAL_002',
        message: `The parameter '${metadata.data}' must be a valid UUID v4 format. Received: '${value}'.`,
      });
    }
    return value;
  }
}
