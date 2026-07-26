import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsPhoneNumberCustom', async: false })
export class IsPhoneNumberCustomConstraint implements ValidatorConstraintInterface {
  validate(phone: any): boolean {
    if (phone === undefined || phone === null || phone === '') {
      return true;
    }
    if (typeof phone !== 'string') {
      return false;
    }
    // E.164 phone format validation: + [1-15 digits] or basic phone pattern 7-15 digits
    const phoneRegex = /^\+?[1-9]\d{1,14}$|^[0-9\-\s\(\)]{7,20}$/;
    return phoneRegex.test(phone.trim());
  }

  defaultMessage(): string {
    return 'phone must be a valid international E.164 phone number string';
  }
}

export function IsPhoneNumberCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsPhoneNumberCustomConstraint,
    });
  };
}
