import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class CareerRoadmapRequestDto {
  @ApiPropertyOptional({ description: 'Target career role (e.g. Software Engineer, AI Researcher)', example: 'Software Engineer' })
  @IsOptional()
  @IsString()
  targetRole?: string;
}
