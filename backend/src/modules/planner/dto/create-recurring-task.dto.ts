import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsDateString,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { RecurrencePattern } from '../constants/recurrence-enums';

export class CreateRecurringTaskDto {
  @ApiProperty({ example: 'Weekly Lab Report Submission' })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({ example: 'Draft and format weekly lab notes.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  taskId?: string;

  @ApiProperty({ enum: RecurrencePattern, example: RecurrencePattern.WEEKLY })
  @IsNotEmpty({ message: 'recurrencePattern is required' })
  @IsEnum(RecurrencePattern)
  recurrencePattern: RecurrencePattern;

  @ApiPropertyOptional({ example: 1, default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  intervalDays?: number;

  @ApiPropertyOptional({ example: 1, description: '0 (Sun) - 6 (Sat)' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(6)
  dayOfWeek?: number;

  @ApiPropertyOptional({ example: 15, description: '1 - 31' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(31)
  dayOfMonth?: number;

  @ApiProperty({ example: '2026-07-26T00:00:00.000Z' })
  @IsNotEmpty({ message: 'startDate is required' })
  @IsDateString()
  startDate: string;

  @ApiPropertyOptional({ example: '2026-12-31T23:59:59.000Z' })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({ example: 10 })
  @IsOptional()
  @IsInt()
  @Min(1)
  maxOccurrences?: number;

  @ApiPropertyOptional({ example: ['2026-08-15'] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  skipDates?: string[];
}
