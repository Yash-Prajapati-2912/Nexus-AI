import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsOptional,
  IsString,
  MaxLength,
  IsUrl,
} from 'class-validator';
import { Gender } from '../constants/gender.enum';
import { CurrentStatus } from '../constants/current-status.enum';
import { IsPhoneNumberCustom } from '../validators/is-phone-number.validator';
import { IsGraduationYearCustom } from '../validators/is-graduation-year.validator';
import { IsSemesterCustom } from '../validators/is-semester.validator';
import { IsDateOfBirthCustom } from '../validators/is-date-of-birth.validator';
import { IsTimezoneCustom } from '../validators/is-timezone.validator';
import { IsCountryCustom } from '../validators/is-country.validator';
import { IsLanguageCustom } from '../validators/is-language.validator';

export class CreateProfileDto {
  @ApiPropertyOptional({
    description: 'Avatar image URL hosted on Cloudinary or CDN',
    example: 'https://res.cloudinary.com/nexus-ai/image/upload/v1/avatars/user123.jpg',
  })
  @IsOptional()
  @IsUrl({}, { message: 'avatar must be a valid URL string' })
  avatar?: string;

  @ApiPropertyOptional({
    description: 'Short professional or student biography',
    example: 'Computer Science sophomore specializing in AI and cloud architecture.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  bio?: string;

  @ApiPropertyOptional({
    description: 'Date of birth (ISO 8601 string or Date format)',
    example: '2003-05-15',
  })
  @IsOptional()
  @IsDateOfBirthCustom()
  dateOfBirth?: string;

  @ApiPropertyOptional({
    enum: Gender,
    description: 'Gender identity',
    example: Gender.MALE,
  })
  @IsOptional()
  @IsEnum(Gender)
  gender?: Gender;

  @ApiPropertyOptional({
    description: 'Contact phone number (E.164 format)',
    example: '+14155552671',
  })
  @IsOptional()
  @IsPhoneNumberCustom()
  phone?: string;

  @ApiPropertyOptional({
    description: 'Country of residence',
    example: 'United States',
  })
  @IsOptional()
  @IsCountryCustom()
  country?: string;

  @ApiPropertyOptional({
    description: 'State or province',
    example: 'California',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  state?: string;

  @ApiPropertyOptional({
    description: 'City of residence',
    example: 'San Francisco',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  city?: string;

  @ApiPropertyOptional({
    description: 'Primary university or educational institution',
    example: 'Stanford University',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  university?: string;

  @ApiPropertyOptional({
    description: 'Degree program being pursued',
    example: 'Bachelor of Science',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  degree?: string;

  @ApiPropertyOptional({
    description: 'Department or major field',
    example: 'Computer Science',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  department?: string;

  @ApiPropertyOptional({
    description: 'Current academic semester (1-12)',
    example: 4,
  })
  @IsOptional()
  @IsSemesterCustom()
  semester?: number;

  @ApiPropertyOptional({
    description: 'Expected graduation year (1950-2100)',
    example: 2026,
  })
  @IsOptional()
  @IsGraduationYearCustom()
  graduationYear?: number;

  @ApiPropertyOptional({
    enum: CurrentStatus,
    description: 'Current academic or professional status',
    example: CurrentStatus.STUDENT,
  })
  @IsOptional()
  @IsEnum(CurrentStatus)
  currentStatus?: CurrentStatus;

  @ApiPropertyOptional({
    description: 'Preferred primary timezone identifier',
    example: 'America/Los_Angeles',
  })
  @IsOptional()
  @IsTimezoneCustom()
  timezone?: string;

  @ApiPropertyOptional({
    description: 'Preferred system language (ISO 639-1 format)',
    example: 'en',
  })
  @IsOptional()
  @IsLanguageCustom()
  language?: string;
}
