import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class WeeklyPlanRequestDto {
  @ApiPropertyOptional({ example: '2026-07-27' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ example: 'Prepare for midterm exams on Friday.' })
  @IsOptional()
  @IsString()
  focusGoals?: string;
}
