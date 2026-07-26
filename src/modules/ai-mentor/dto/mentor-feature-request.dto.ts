import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsUUID } from 'class-validator';

export class MentorFeatureRequestDto {
  @ApiPropertyOptional({ description: 'Specific query or focus area' })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiPropertyOptional({ description: 'Existing conversation UUID to attach to' })
  @IsOptional()
  @IsUUID()
  conversationId?: string;
}
