import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { NotificationCategory } from '../constants/notification-enums.constants';

export class NotificationResponseDto {
  @ApiProperty({ description: 'Notification UUID' })
  id: string;

  @ApiProperty({ description: 'Notification Category', enum: NotificationCategory })
  category: NotificationCategory;

  @ApiProperty({ description: 'Notification Title' })
  title: string;

  @ApiProperty({ description: 'Notification Body' })
  body: string;

  @ApiProperty({ description: 'Is read?' })
  isRead: boolean;

  @ApiPropertyOptional({ description: 'Read timestamp' })
  readAt?: Date | null;

  @ApiPropertyOptional({ description: 'Deep link URL' })
  deepLink?: string | null;

  @ApiProperty({ description: 'Created timestamp' })
  createdAt: Date;
}
