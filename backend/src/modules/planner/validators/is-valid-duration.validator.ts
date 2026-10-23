import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsValidDurationMinutes', async: false })
export class IsValidDurationMinutesConstraint implements ValidatorConstraintInterface {
  validate(duration: any): boolean {
    if (duration === undefined || duration === null) {
      return true;
    }
    const num = Number(duration);
    if (!Number.isInteger(num)) {
      return false;
    }
    return num >= 1 && num <= 10080; // Max 1 week (7 days * 24h * 60m)
  }

  defaultMessage(): string {
    return 'durationInMinutes must be a valid integer between 1 and 10080 minutes (max 7 days)';
  }
}

export function IsValidDurationMinutes(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsValidDurationMinutesConstraint,
    });
  };
}
