import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class CreateEducationDto {
  @ApiProperty({
    description: 'Name of educational institution or university',
    example: 'Stanford University',
  })
  @IsNotEmpty({ message: 'institution is required' })
  @IsString()
  @MaxLength(255)
  institution: string;

  @ApiProperty({
    description: 'Degree or certification title',
    example: 'Bachelor of Science',
  })
  @IsNotEmpty({ message: 'degree is required' })
  @IsString()
  @MaxLength(255)
  degree: string;

  @ApiProperty({
    description: 'Field of study or major specialization',
    example: 'Computer Science',
  })
  @IsNotEmpty({ message: 'fieldOfStudy is required' })
  @IsString()
  @MaxLength(255)
  fieldOfStudy: string;

  @ApiProperty({
    description: 'Start date of enrollment (ISO date string YYYY-MM-DD)',
    example: '2022-09-01',
  })
  @IsNotEmpty({ message: 'startDate is required' })
  @IsDateString({}, { message: 'startDate must be a valid ISO date string' })
  startDate: string;

  @ApiPropertyOptional({
    description: 'End date of completion (ISO date string YYYY-MM-DD)',
    example: '2026-06-15',
  })
  @IsOptional()
  @IsDateString({}, { message: 'endDate must be a valid ISO date string' })
  endDate?: string;

  @ApiPropertyOptional({
    description: 'Flag indicating whether this program is currently active',
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  isCurrent?: boolean;

  @ApiPropertyOptional({
    description: 'Grade, CGPA, or honors distinction achieved',
    example: '3.9 GPA',
  })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  grade?: string;

  @ApiPropertyOptional({
    description: 'Additional description of coursework, achievements, or activities',
    example: 'Dean List for 4 consecutive semesters.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;
}
