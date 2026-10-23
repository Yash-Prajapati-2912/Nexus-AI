import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class WorkloadAnalysisRequestDto {
  @ApiPropertyOptional({ example: 'Analyze workload for next 14 days.' })
  @IsOptional()
  @IsString()
  notes?: string;
}
