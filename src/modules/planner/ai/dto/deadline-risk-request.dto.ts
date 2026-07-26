import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class DeadlineRiskRequestDto {
  @ApiPropertyOptional({ example: 'Evaluate risks for current week assignments.' })
  @IsOptional()
  @IsString()
  contextNotes?: string;
}
