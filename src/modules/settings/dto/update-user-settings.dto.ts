import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsString, IsObject } from 'class-validator';
import { ThemeMode, StartOfWeek } from '../constants/settings-enums.constants';

export class UpdateUserSettingsDto {
  @ApiPropertyOptional({ description: 'UI Theme choice', enum: ThemeMode })
  @IsOptional()
  @IsEnum(ThemeMode)
  theme?: ThemeMode;

  @ApiPropertyOptional({ description: 'System language locale', example: 'en-US' })
  @IsOptional()
  @IsString()
  language?: string;

  @ApiPropertyOptional({ description: 'User timezone string', example: 'UTC' })
  @IsOptional()
  @IsString()
  timezone?: string;

  @ApiPropertyOptional({ description: 'Date formatting string', example: 'YYYY-MM-DD' })
  @IsOptional()
  @IsString()
  dateFormat?: string;

  @ApiPropertyOptional({ description: 'Time formatting string', example: '24h' })
  @IsOptional()
  @IsString()
  timeFormat?: string;

  @ApiPropertyOptional({ description: 'Start day of calendar week', enum: StartOfWeek })
  @IsOptional()
  @IsEnum(StartOfWeek)
  startOfWeek?: StartOfWeek;

  @ApiPropertyOptional({ description: 'User privacy settings object' })
  @IsOptional()
  @IsObject()
  privacySettings?: Record<string, any>;
}
