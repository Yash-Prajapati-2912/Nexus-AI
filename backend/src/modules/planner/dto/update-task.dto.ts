import { PartialType, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsInt, IsOptional, Min } from 'class-validator';
import { CreateTaskDto } from './create-task.dto';

export class UpdateTaskDto extends PartialType(CreateTaskDto) {
  @ApiPropertyOptional({
    description: 'Actual time spent on task in minutes',
    example: 95,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  actualDurationMinutes?: number;

  @ApiPropertyOptional({
    description: 'Completion date and time (ISO string)',
    example: '2026-07-27T15:30:00.000Z',
  })
  @IsOptional()
  @IsDateString()
  completedAt?: string;
}
