import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsOptional, IsUUID, IsEnum } from 'class-validator';
import { ConversationType, MentorProviderType } from '../constants/mentor-enums.constants';

export class ChatRequestDto {
  @ApiProperty({ description: 'User chat prompt or query', example: 'How should I prioritize my exam prep and budget this week?' })
  @IsNotEmpty()
  @IsString()
  message: string;

  @ApiPropertyOptional({ description: 'Existing conversation UUID to continue session' })
  @IsOptional()
  @IsUUID()
  conversationId?: string;

  @ApiPropertyOptional({ description: 'Domain focus type', enum: ConversationType, default: ConversationType.GENERAL })
  @IsOptional()
  @IsEnum(ConversationType)
  conversationType?: ConversationType = ConversationType.GENERAL;

  @ApiPropertyOptional({ description: 'Target AI Provider override', enum: MentorProviderType })
  @IsOptional()
  @IsEnum(MentorProviderType)
  provider?: MentorProviderType;
}
