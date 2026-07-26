import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsLanguageCustom', async: false })
export class IsLanguageCustomConstraint implements ValidatorConstraintInterface {
  validate(language: any): boolean {
    if (language === undefined || language === null || language === '') {
      return true;
    }
    if (typeof language !== 'string') {
      return false;
    }
    const langRegex = /^[a-z]{2,3}(-[A-Z]{2})?$/i;
    return langRegex.test(language.trim());
  }

  defaultMessage(): string {
    return 'language must be a valid ISO 639-1 language tag (e.g. "en", "es", "fr", "en-US")';
  }
}

export function IsLanguageCustom(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      constraints: [],
      validator: IsLanguageCustomConstraint,
    });
  };
}
