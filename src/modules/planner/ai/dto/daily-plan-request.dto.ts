import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class DailyPlanRequestDto {
  @ApiPropertyOptional({ example: '2026-07-27' })
  @IsOptional()
  @IsDateString()
  targetDate?: string;

  @ApiPropertyOptional({ example: 'Include 2-hour morning deep focus session.' })
  @IsOptional()
  @IsString()
  preferences?: string;
}
