import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsTimezoneCustom', async: false })
export class IsTimezoneCustomConstraint implements ValidatorConstraintInterface {
  validate(timezone: any): boolean {
    if (timezone === undefined || timezone === null || timezone === '') {
      return true;
    }
    if (typeof timezone !== 'string') {
      return false;
    }
    try {
      Intl.DateTimeFormat(undefined, { timeZone: timezone.trim() });
      return true;
    } catch (e) {
      // Fallback for standard offset strings like UTC, GMT, UTC+5:30
      const standardOffsetRegex = /^(UTC|GMT)([+-]\d{1,2}(:\d{2})?)?$/i;
      return standardOffsetRegex.test(timezone.trim());
    }
  }

  defaultMessage(): string {
    return 'timezone must be a valid IANA timezone identifier string (e.g. "UTC", "America/New_York", "Asia/Kolkata")';
  }
}

export function IsTimezoneCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsTimezoneCustomConstraint,
    });
  };
}
