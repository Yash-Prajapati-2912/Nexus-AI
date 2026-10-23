import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { IsAfterDate } from '../validators/is-valid-date-range.validator';

export class CreateCalendarEventDto {
  @ApiProperty({ example: 'Algorithms Lecture & Workshop' })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({ example: 'Room 302, Computer Science Building.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiProperty({ example: '2026-07-27T10:00:00.000Z' })
  @IsNotEmpty({ message: 'startTime is required' })
  @IsDateString()
  startTime: string;

  @ApiProperty({ example: '2026-07-27T11:30:00.000Z' })
  @IsNotEmpty({ message: 'endTime is required' })
  @IsDateString()
  @IsAfterDate('startTime')
  endTime: string;

  @ApiPropertyOptional({ example: false })
  @IsOptional()
  @IsBoolean()
  isAllDay?: boolean;

  @ApiPropertyOptional({ example: 'Hall B, Stanford Campus' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  location?: string;

  @ApiPropertyOptional({ example: '#3B82F6' })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  colour?: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  linkedTaskId?: string;

  @ApiPropertyOptional({ example: 'a1a2a3a4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  linkedAssignmentId?: string;

  @ApiPropertyOptional({ example: 'America/Los_Angeles' })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  timezone?: string;
}
