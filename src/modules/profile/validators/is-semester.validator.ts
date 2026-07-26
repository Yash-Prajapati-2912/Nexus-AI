import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsSemesterCustom', async: false })
export class IsSemesterCustomConstraint implements ValidatorConstraintInterface {
  validate(semester: any): boolean {
    if (semester === undefined || semester === null) {
      return true;
    }
    const numSemester = Number(semester);
    if (!Number.isInteger(numSemester)) {
      return false;
    }
    return numSemester >= 1 && numSemester <= 12;
  }

  defaultMessage(): string {
    return 'semester must be an integer between 1 and 12';
  }
}

export function IsSemesterCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsSemesterCustomConstraint,
    });
  };
}
