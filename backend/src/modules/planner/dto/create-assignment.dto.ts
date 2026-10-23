import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { TaskPriority } from '../constants/task-priority.enum';
import { AssignmentStatus } from '../constants/assignment-status.enum';

export class CreateAssignmentDto {
  @ApiProperty({
    description: 'Assignment title',
    example: 'Operating Systems Kernel Module Lab',
  })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({
    description: 'Assignment instructions or problem statement details',
    example: 'Implement custom process scheduler in Linux C.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiProperty({
    description: 'Subject or course title',
    example: 'Computer Systems Architecture',
  })
  @IsNotEmpty({ message: 'subject is required' })
  @IsString()
  @MaxLength(255)
  subject: string;

  @ApiPropertyOptional({
    description: 'Course code identifier',
    example: 'CS 140',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  course?: string;

  @ApiPropertyOptional({
    description: 'Academic semester integer (1-12)',
    example: 4,
  })
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(12)
  semester?: number;

  @ApiPropertyOptional({
    enum: TaskPriority,
    description: 'Priority level',
    example: TaskPriority.HIGH,
  })
  @IsOptional()
  @IsEnum(TaskPriority)
  priority?: TaskPriority;

  @ApiPropertyOptional({
    enum: AssignmentStatus,
    description: 'Assignment status',
    example: AssignmentStatus.PENDING,
  })
  @IsOptional()
  @IsEnum(AssignmentStatus)
  status?: AssignmentStatus;

  @ApiProperty({
    description: 'Submission deadline (ISO 8601 string)',
    example: '2026-08-05T23:59:59.000Z',
  })
  @IsNotEmpty({ message: 'deadline is required' })
  @IsDateString({}, { message: 'deadline must be a valid ISO date string' })
  deadline: string;

  @ApiPropertyOptional({
    description: 'Submission URL link (GitHub PR, Canvas, Gradescope)',
    example: 'https://github.com/student/cs140-lab1',
  })
  @IsOptional()
  @IsUrl({}, { message: 'submissionLink must be a valid URL string' })
  submissionLink?: string;

  @ApiPropertyOptional({
    description: 'Estimated hours required to complete',
    example: 12.5,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  estimatedHours?: number;

  @ApiPropertyOptional({
    description: 'Total maximum marks for assignment',
    example: 100,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  totalMarks?: number;

  @ApiPropertyOptional({
    description: 'Marks obtained by student',
    example: 94.5,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  obtainedMarks?: number;

  @ApiPropertyOptional({
    description: 'Uploaded attachments metadata array',
    example: [{ name: 'spec.pdf', url: 'https://cdn.example.com/spec.pdf' }],
  })
  @IsOptional()
  @IsArray()
  attachments?: Record<string, any>[];
}
