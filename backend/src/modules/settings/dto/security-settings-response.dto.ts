import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class SecuritySettingsResponseDto {
  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Session timeout in minutes' })
  sessionTimeoutMinutes: number;

  @ApiProperty({ description: 'Is MFA enabled?' })
  mfaEnabled: boolean;

  @ApiPropertyOptional({ description: 'Trusted devices list' })
  trustedDevices?: Record<string, any>[] | null;
}
