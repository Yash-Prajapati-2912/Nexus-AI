import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
  Min,
} from 'class-validator';
import { TimeLogEntryType } from '../constants/study-plan-enums';
import { IsAfterDate } from '../validators/is-valid-date-range.validator';

export class CreateTimeLogDto {
  @ApiProperty({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  @IsNotEmpty({ message: 'taskId is required' })
  @IsUUID('4')
  taskId: string;

  @ApiProperty({ example: '2026-07-27T10:00:00.000Z' })
  @IsNotEmpty({ message: 'startTime is required' })
  @IsDateString()
  startTime: string;

  @ApiProperty({ example: '2026-07-27T11:45:00.000Z' })
  @IsNotEmpty({ message: 'endTime is required' })
  @IsDateString()
  @IsAfterDate('startTime')
  endTime: string;

  @ApiPropertyOptional({ example: 105, description: 'Duration in minutes' })
  @IsOptional()
  @IsInt()
  @Min(1)
  durationMinutes?: number;

  @ApiPropertyOptional({ enum: TimeLogEntryType, example: TimeLogEntryType.MANUAL })
  @IsOptional()
  @IsEnum(TimeLogEntryType)
  entryType?: TimeLogEntryType;

  @ApiPropertyOptional({ example: 'Logged focus time via manual stopwatch.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  notes?: string;
}
