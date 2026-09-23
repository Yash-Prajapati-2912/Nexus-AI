import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';
import { IsValidDurationMinutes } from '../validators/is-valid-duration.validator';
import { IsAfterDate } from '../validators/is-valid-date-range.validator';

export class CreateTaskDto {
  @ApiProperty({
    description: 'Task title',
    example: 'Complete Linear Algebra Problem Set 3',
  })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({
    description: 'Detailed task description',
    example: 'Solve questions 1 through 10 from Chapter 4.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiPropertyOptional({
    description: 'Category UUID PK',
    example: 'c1c2c3c4-e5f6-7890-abcd-ef1234567890',
  })
  @IsOptional()
  @IsUUID('4', { message: 'categoryId must be a valid UUID' })
  categoryId?: string;

  @ApiPropertyOptional({
    description: 'Extracted task category',
    example: 'Assignments & Coursework',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  category?: string;

  @ApiPropertyOptional({
    enum: TaskPriority,
    description: 'Task priority level',
    example: TaskPriority.HIGH,
  })
  @IsOptional()
  @IsEnum(TaskPriority)
  priority?: TaskPriority;

  @ApiPropertyOptional({
    enum: TaskStatus,
    description: 'Task execution status',
    example: TaskStatus.TODO,
  })
  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @ApiPropertyOptional({
    description: 'Estimated duration in minutes (1-10080)',
    example: 120,
  })
  @IsOptional()
  @IsValidDurationMinutes()
  estimatedDurationMinutes?: number;

  @ApiPropertyOptional({
    description: 'Start date and time (ISO 8601 string)',
    example: '2026-07-26T09:00:00.000Z',
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    description: 'Due date and time (ISO 8601 string)',
    example: '2026-07-28T23:59:59.000Z',
  })
  @IsOptional()
  @IsDateString()
  @IsAfterDate('startDate')
  dueDate?: string;

  @ApiPropertyOptional({
    description: 'Pin task flag',
    example: false,
  })
  @IsOptional()
  @IsBoolean()
  isPinned?: boolean;

  @ApiPropertyOptional({
    description: 'Archive task flag',
    example: false,
  })
  @IsOptional()
  @IsBoolean()
  isArchived?: boolean;

  @ApiPropertyOptional({
    description: 'Mark task as important flag',
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  isImportant?: boolean;

  @ApiPropertyOptional({
    description: 'Custom hex color tag',
    example: '#3B82F6',
  })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  colour?: string;

  @ApiPropertyOptional({
    description: 'Personal notes or hints',
    example: 'Review lecture recordings from Tuesday before starting.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  notes?: string;

  @ApiPropertyOptional({
    description: 'Array of label UUIDs to associate with task',
    example: ['l1l2l3l4-e5f6-7890-abcd-ef1234567890'],
  })
  @IsOptional()
  @IsArray()
  @IsUUID('4', { each: true, message: 'Each label ID must be a valid UUID' })
  labelIds?: string[];

  @ApiPropertyOptional({
    description: 'Custom metadata payload',
    example: { source: 'manual', difficulty: 'hard' },
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, any>;
}
