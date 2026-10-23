import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsUUID } from 'class-validator';

export class TimeLogQueryDto {
  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  taskId?: string;

  @ApiPropertyOptional({ description: 'Start date (ISO date string)' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'End date (ISO date string)' })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
