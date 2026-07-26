import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ReminderFrequency } from '../constants/notification-enums.constants';

export class NotificationPreferenceResponseDto {
  @ApiProperty({ description: 'Push notification toggle' })
  pushEnabled: boolean;

  @ApiProperty({ description: 'Email notification toggle' })
  emailEnabled: boolean;

  @ApiProperty({ description: 'In-app notification toggle' })
  inAppEnabled: boolean;

  @ApiProperty({ description: 'SMS notification toggle' })
  smsEnabled: boolean;

  @ApiPropertyOptional({ description: 'Quiet hours start time' })
  quietHoursStart?: string | null;

  @ApiPropertyOptional({ description: 'Quiet hours end time' })
  quietHoursEnd?: string | null;

  @ApiProperty({ description: 'Reminder frequency preference', enum: ReminderFrequency })
  reminderFrequency: ReminderFrequency;
}
