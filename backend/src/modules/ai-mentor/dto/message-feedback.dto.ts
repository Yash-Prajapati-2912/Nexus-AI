import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsInt, Min, Max, IsOptional, IsString, IsUUID, IsBoolean } from 'class-validator';

export class MessageFeedbackDto {
  @ApiPropertyOptional({ description: 'Target assistant message UUID' })
  @IsOptional()
  @IsUUID()
  messageId?: string;

  @ApiProperty({ description: 'Feedback rating score from 1 to 5', example: 5 })
  @IsNotEmpty()
  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @ApiPropertyOptional({ description: 'Optional feedback comments', example: 'Very clear explanation!' })
  @IsOptional()
  @IsString()
  comment?: string;

  @ApiPropertyOptional({ description: 'Optional feedback comments alias', example: 'Very clear explanation!' })
  @IsOptional()
  @IsString()
  comments?: string;

  @ApiPropertyOptional({ description: 'Optional feedback category or type', example: 'HELPFUL' })
  @IsOptional()
  @IsString()
  feedbackType?: string;

  @ApiPropertyOptional({ description: 'Optional feedback category alias from client', example: 'GENERAL' })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({ description: 'Optional helpfulness boolean flag' })
  @IsOptional()
  @IsBoolean()
  isHelpful?: boolean;
}
