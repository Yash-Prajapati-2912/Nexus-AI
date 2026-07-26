import { ApiProperty } from '@nestjs/swagger';
import { ThemePreference } from '../constants/theme.enum';
import {
  INotificationPreferences,
  IStudyPreferences,
  IReminderPreferences,
  IAiPreferences,
  IPrivacySettings,
} from '../interfaces/user-preference.interface';

export class UserPreferenceResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'b2c3d4e5-f6a7-8901-bcde-f23456789012' })
  profileId: string;

  @ApiProperty({ enum: ThemePreference, example: ThemePreference.DARK })
  theme: ThemePreference;

  @ApiProperty({ example: 'en' })
  language: string;

  @ApiProperty()
  notificationPreferences: INotificationPreferences;

  @ApiProperty()
  studyPreferences: IStudyPreferences;

  @ApiProperty()
  reminderPreferences: IReminderPreferences;

  @ApiProperty()
  aiPreferences: IAiPreferences;

  @ApiProperty()
  privacySettings: IPrivacySettings;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
