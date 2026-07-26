import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsOptional,
  IsString,
  IsInt,
  Min,
  Max,
  IsArray,
  IsUUID,
  IsDateString,
} from 'class-validator';
import { Type, Transform } from 'class-transformer';
import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';
import { TaskQuickFilter, TaskSortField } from '../constants/planner.constants';

export class TaskQueryDto {
  @ApiPropertyOptional({
    description: 'Search string to filter by title, description, or notes',
    example: 'Algebra',
  })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter by category UUID',
    example: 'c1c2c3c4-e5f6-7890-abcd-ef1234567890',
  })
  @IsOptional()
  @IsUUID('4')
  categoryId?: string;

  @ApiPropertyOptional({
    description: 'Filter by label UUIDs (comma-separated or array)',
    example: 'l1l2l3l4-e5f6-7890-abcd-ef1234567890',
  })
  @IsOptional()
  @Transform(({ value }) => (typeof value === 'string' ? value.split(',') : value))
  @IsArray()
  @IsUUID('4', { each: true })
  labelIds?: string[];

  @ApiPropertyOptional({
    enum: TaskPriority,
    description: 'Filter by priority level',
    example: TaskPriority.HIGH,
  })
  @IsOptional()
  @IsEnum(TaskPriority)
  priority?: TaskPriority;

  @ApiPropertyOptional({
    enum: TaskStatus,
    description: 'Filter by status',
    example: TaskStatus.TODO,
  })
  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @ApiPropertyOptional({
    enum: TaskQuickFilter,
    description: 'Predefined quick filter preset (TODAY, TOMORROW, THIS_WEEK, THIS_MONTH, PENDING, COMPLETED, ARCHIVED, PINNED, IMPORTANT)',
    example: TaskQuickFilter.THIS_WEEK,
  })
  @IsOptional()
  @IsEnum(TaskQuickFilter)
  quickFilter?: TaskQuickFilter;

  @ApiPropertyOptional({ description: 'Filter range start date (ISO date string)' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'Filter range end date (ISO date string)' })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({
    enum: TaskSortField,
    description: 'Field to sort tasks by',
    example: TaskSortField.DUE_DATE,
    default: TaskSortField.DUE_DATE,
  })
  @IsOptional()
  @IsEnum(TaskSortField)
  sortBy?: TaskSortField = TaskSortField.DUE_DATE;

  @ApiPropertyOptional({
    enum: ['ASC', 'DESC'],
    description: 'Sort order direction',
    example: 'ASC',
    default: 'ASC',
  })
  @IsOptional()
  @IsEnum(['ASC', 'DESC'])
  sortOrder?: 'ASC' | 'DESC' = 'ASC';

  @ApiPropertyOptional({ description: 'Page number', example: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ description: 'Items per page', example: 10, default: 10 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 10;
}
