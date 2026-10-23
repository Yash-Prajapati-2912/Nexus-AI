import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class GenerateStudyPlanRequestDto {
  @ApiPropertyOptional({ example: 4, description: 'Target daily study hours' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(16)
  targetDailyHours?: number;

  @ApiPropertyOptional({ example: 'Prioritize Operating Systems and Linear Algebra.' })
  @IsOptional()
  @IsString()
  preferences?: string;
}
