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
    const tzStr = timezone.trim();
    try {
      Intl.DateTimeFormat(undefined, { timeZone: tzStr });
      return true;
    } catch (e) {
      // Fallback for standard offset strings (UTC+5:30, GMT-8, +05:30) and combined format (IST (UTC+05:30))
      const combinedOffsetRegex = /^([A-Z0-9_\/\-\s]+)?\s*(\((UTC|GMT)?[+-]\d{1,2}(:\d{2})?\))?$/i;
      const standardOffsetRegex = /^(UTC|GMT)?([+-]\d{1,2}(:\d{2})?)$/i;
      const abbrRegex = /^[A-Z]{3,5}$/i;
      return combinedOffsetRegex.test(tzStr) || standardOffsetRegex.test(tzStr) || abbrRegex.test(tzStr);
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
