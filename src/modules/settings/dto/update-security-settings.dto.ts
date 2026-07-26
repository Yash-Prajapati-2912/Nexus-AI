import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsNumber, IsBoolean } from 'class-validator';

export class UpdateSecuritySettingsDto {
  @ApiPropertyOptional({ description: 'Inactivity session timeout in minutes', example: 60 })
  @IsOptional()
  @IsNumber()
  sessionTimeoutMinutes?: number;

  @ApiPropertyOptional({ description: 'Enable multi-factor authentication?' })
  @IsOptional()
  @IsBoolean()
  mfaEnabled?: boolean;
}
