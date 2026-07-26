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
import { StudySessionStatus } from '../constants/study-plan-enums';

export class CreateStudySessionDto {
  @ApiProperty({ example: 'sp1sp2sp3-e5f6-7890-abcd-ef1234567890' })
  @IsNotEmpty({ message: 'studyPlanId is required' })
  @IsUUID('4')
  studyPlanId: string;

  @ApiProperty({ example: '2026-07-27T14:00:00.000Z' })
  @IsNotEmpty({ message: 'startTime is required' })
  @IsDateString()
  startTime: string;

  @ApiPropertyOptional({ example: '2026-07-27T16:00:00.000Z' })
  @IsOptional()
  @IsDateString()
  endTime?: string;

  @ApiPropertyOptional({ example: 120, description: 'Duration in minutes' })
  @IsOptional()
  @IsInt()
  @Min(0)
  durationMinutes?: number;

  @ApiPropertyOptional({ example: 15, description: 'Break duration in minutes' })
  @IsOptional()
  @IsInt()
  @Min(0)
  breakDurationMinutes?: number;

  @ApiPropertyOptional({ example: 'Reviewed chapter 4 memory paging concepts.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  notes?: string;

  @ApiPropertyOptional({ enum: StudySessionStatus, example: StudySessionStatus.COMPLETED })
  @IsOptional()
  @IsEnum(StudySessionStatus)
  completionStatus?: StudySessionStatus;
}
