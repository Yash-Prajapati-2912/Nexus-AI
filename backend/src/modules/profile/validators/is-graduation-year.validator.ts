import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsGraduationYearCustom', async: false })
export class IsGraduationYearCustomConstraint implements ValidatorConstraintInterface {
  validate(year: any): boolean {
    if (year === undefined || year === null || year === 0 || year === '0' || year === '') {
      return true;
    }
    const numYear = Number(year);
    if (!Number.isInteger(numYear)) {
      return false;
    }
    return numYear >= 1950 && numYear <= 2100;
  }

  defaultMessage(): string {
    return 'graduationYear must be a valid integer between 1950 and 2100';
  }
}

export function IsGraduationYearCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsGraduationYearCustomConstraint,
    });
  };
}
