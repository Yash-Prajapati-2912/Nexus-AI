import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class StudyAnalysisRequestDto {
  @ApiPropertyOptional({ description: 'Optional subject focus override' })
  @IsOptional()
  @IsString()
  subjectFocus?: string;
}
