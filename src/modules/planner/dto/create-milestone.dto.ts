import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { MilestoneStatus } from '../constants/milestone-enums';

export class CreateMilestoneDto {
  @ApiProperty({ example: 'Complete Operating Systems Final Project Phase 1' })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({ example: 'Implement thread synchronization primitive.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiProperty({ example: '2026-08-10T23:59:59.000Z' })
  @IsNotEmpty({ message: 'targetDate is required' })
  @IsDateString()
  targetDate: string;

  @ApiPropertyOptional({ enum: MilestoneStatus, example: MilestoneStatus.PENDING })
  @IsOptional()
  @IsEnum(MilestoneStatus)
  status?: MilestoneStatus;

  @ApiPropertyOptional({ example: 45.0, description: 'Progress percentage (0-100%)' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  progressPercentage?: number;

  @ApiPropertyOptional({ example: 'a1a2a3a4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  linkedAssignmentId?: string;
}
