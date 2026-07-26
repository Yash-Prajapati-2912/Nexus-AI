import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsDateOfBirthCustom', async: false })
export class IsDateOfBirthCustomConstraint implements ValidatorConstraintInterface {
  validate(dob: any): boolean {
    if (dob === undefined || dob === null || dob === '') {
      return true;
    }
    const date = new Date(dob);
    if (isNaN(date.getTime())) {
      return false;
    }
    const now = new Date();
    if (date >= now) {
      return false;
    }
    const age = now.getFullYear() - date.getFullYear();
    return age >= 10 && age <= 120;
  }

  defaultMessage(): string {
    return 'dateOfBirth must be a valid date in the past for an age between 10 and 120 years';
  }
}

export function IsDateOfBirthCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsDateOfBirthCustomConstraint,
    });
  };
}
