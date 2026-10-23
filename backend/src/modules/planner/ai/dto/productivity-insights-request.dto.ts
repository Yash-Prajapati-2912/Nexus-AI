import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class ProductivityInsightsRequestDto {
  @ApiPropertyOptional({ example: 'Focus on improving study consistency.' })
  @IsOptional()
  @IsString()
  goalFocus?: string;
}
