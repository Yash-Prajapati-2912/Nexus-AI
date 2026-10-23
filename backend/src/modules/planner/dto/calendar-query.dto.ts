import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, IsDateString } from 'class-validator';

export enum CalendarViewMode {
  DAY = 'DAY',
  WEEK = 'WEEK',
  MONTH = 'MONTH',
  AGENDA = 'AGENDA',
}

export class CalendarQueryDto {
  @ApiPropertyOptional({ enum: CalendarViewMode, example: CalendarViewMode.WEEK })
  @IsOptional()
  @IsEnum(CalendarViewMode)
  viewMode?: CalendarViewMode = CalendarViewMode.WEEK;

  @ApiPropertyOptional({ description: 'Start date range (ISO date string)' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'End date range (ISO date string)' })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({ description: 'Search title or location', example: 'Algorithms' })
  @IsOptional()
  @IsString()
  search?: string;
}
