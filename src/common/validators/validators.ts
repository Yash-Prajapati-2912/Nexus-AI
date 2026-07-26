import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
import { REGEX_PATTERNS } from '../constants';

/**
 * Custom `@IsStrongPassword()` Class-Validator Decorator.
 * Verifies password contains minimum 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character.
 */
export function IsStrongPassword(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isStrongPassword',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(value: unknown) {
          return typeof value === 'string' && REGEX_PATTERNS.STRONG_PASSWORD.test(value);
        },
        defaultMessage(args: ValidationArguments) {
          return `${args.property} must contain at least 8 characters, 1 uppercase, 1 lowercase, 1 digit, and 1 special character (@$!%*?&).`;
        },
      },
    });
  };
}

/**
 * Custom `@IsSlug()` Class-Validator Decorator.
 */
export function IsSlug(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isSlug',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(value: unknown) {
          return typeof value === 'string' && REGEX_PATTERNS.SLUG.test(value);
        },
        defaultMessage(args: ValidationArguments) {
          return `${args.property} must be a valid lower-case hyphenated slug string.`;
        },
      },
    });
  };
}
