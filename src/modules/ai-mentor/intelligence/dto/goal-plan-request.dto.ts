import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class GoalPlanRequestDto {
  @ApiPropertyOptional({ description: 'Goal title to decompose into milestones' })
  @IsOptional()
  @IsString()
  goalTitle?: string;
}
