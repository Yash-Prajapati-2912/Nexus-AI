import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsArray, IsOptional, IsString, IsUUID } from 'class-validator';

export class PrioritiseTasksRequestDto {
  @ApiPropertyOptional({ example: ['t1t2t3t4-e5f6-7890-abcd-ef1234567890'] })
  @IsOptional()
  @IsArray()
  @IsUUID('4', { each: true })
  taskIds?: string[];

  @ApiPropertyOptional({ example: 'Focus on upcoming midterm exam prep.' })
  @IsOptional()
  @IsString()
  additionalDirectives?: string;
}
