import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsCountryCustom', async: false })
export class IsCountryCustomConstraint implements ValidatorConstraintInterface {
  validate(country: any): boolean {
    if (country === undefined || country === null || country === '') {
      return true;
    }
    if (typeof country !== 'string') {
      return false;
    }
    const countryTrimmed = country.trim();
    return countryTrimmed.length >= 2 && countryTrimmed.length <= 100;
  }

  defaultMessage(): string {
    return 'country must be a valid country name or ISO code between 2 and 100 characters';
  }
}

export function IsCountryCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsCountryCustomConstraint,
    });
  };
}
