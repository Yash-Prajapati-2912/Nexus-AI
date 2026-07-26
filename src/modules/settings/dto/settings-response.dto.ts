import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ThemeMode, StartOfWeek } from '../constants/settings-enums.constants';

export class SettingsResponseDto {
  @ApiProperty({ description: 'Settings record UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Theme choice', enum: ThemeMode })
  theme: ThemeMode;

  @ApiProperty({ description: 'Language locale', example: 'en-US' })
  language: string;

  @ApiProperty({ description: 'Timezone string', example: 'UTC' })
  timezone: string;

  @ApiProperty({ description: 'Date format string' })
  dateFormat: string;

  @ApiProperty({ description: 'Time format string' })
  timeFormat: string;

  @ApiProperty({ description: 'Start day of week', enum: StartOfWeek })
  startOfWeek: StartOfWeek;

  @ApiPropertyOptional({ description: 'Privacy settings' })
  privacySettings?: Record<string, any> | null;
}
