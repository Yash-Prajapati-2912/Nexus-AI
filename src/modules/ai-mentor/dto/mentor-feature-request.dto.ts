import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsUUID } from 'class-validator';

export class MentorFeatureRequestDto {
  @ApiPropertyOptional({ description: 'Specific query or focus area' })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiPropertyOptional({ description: 'Specific message content from chat client' })
  @IsOptional()
  @IsString()
  message?: string;

  @ApiPropertyOptional({ description: 'Specific prompt content from chat client' })
  @IsOptional()
  @IsString()
  prompt?: string;

  @ApiPropertyOptional({ description: 'Existing conversation UUID to attach to' })
  @IsOptional()
  @IsUUID()
  conversationId?: string;
}
