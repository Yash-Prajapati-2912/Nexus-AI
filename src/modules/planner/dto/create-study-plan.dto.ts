import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';
import { TaskPriority } from '../constants/task-priority.enum';
import { StudyPlanStatus } from '../constants/study-plan-enums';
import { IsAfterDate } from '../validators/is-valid-date-range.validator';

export class CreateStudyPlanDto {
  @ApiProperty({ example: 'Operating Systems & Kernel Concepts' })
  @IsNotEmpty({ message: 'subject is required' })
  @IsString()
  @MaxLength(255)
  subject: string;

  @ApiPropertyOptional({ example: 'CS 140' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  course?: string;

  @ApiPropertyOptional({ example: 40.0, default: 20.0 })
  @IsOptional()
  @IsNumber()
  @Min(0.5)
  targetHours?: number;

  @ApiProperty({ example: '2026-08-01T00:00:00.000Z' })
  @IsNotEmpty({ message: 'startDate is required' })
  @IsDateString()
  startDate: string;

  @ApiProperty({ example: '2026-08-31T23:59:59.000Z' })
  @IsNotEmpty({ message: 'endDate is required' })
  @IsDateString()
  @IsAfterDate('startDate')
  endDate: string;

  @ApiPropertyOptional({ enum: TaskPriority, example: TaskPriority.HIGH })
  @IsOptional()
  @IsEnum(TaskPriority)
  priority?: TaskPriority;

  @ApiPropertyOptional({ enum: StudyPlanStatus, example: StudyPlanStatus.ACTIVE })
  @IsOptional()
  @IsEnum(StudyPlanStatus)
  status?: StudyPlanStatus;
}
