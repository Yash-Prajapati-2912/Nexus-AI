import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';

/**
 * Custom decorator validating that integer is a valid calendar month (1 - 12).
 */
export function IsValidMonth(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isValidMonth',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(value: any, _args: ValidationArguments) {
          return typeof value === 'number' && Number.isInteger(value) && value >= 1 && value <= 12;
        },
        defaultMessage(_args: ValidationArguments) {
          return `${propertyName} must be an integer between 1 and 12 representing a valid calendar month`;
        },
      },
    });
  };
}
