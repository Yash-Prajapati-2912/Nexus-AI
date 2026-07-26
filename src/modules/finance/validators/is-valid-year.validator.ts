import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';

/**
 * Custom decorator validating that integer is a reasonable calendar year (e.g. 2000 - 2100).
 */
export function IsValidYear(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isValidYear',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(value: any, _args: ValidationArguments) {
          return (
            typeof value === 'number' &&
            Number.isInteger(value) &&
            value >= 2000 &&
            value <= 2100
          );
        },
        defaultMessage(_args: ValidationArguments) {
          return `${propertyName} must be a 4-digit year between 2000 and 2100`;
        },
      },
    });
  };
}
