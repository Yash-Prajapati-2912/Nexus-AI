import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class ActionPlanRequestDto {
  @ApiPropertyOptional({ description: 'Target objective title for action plan' })
  @IsOptional()
  @IsString()
  objective?: string;
}
