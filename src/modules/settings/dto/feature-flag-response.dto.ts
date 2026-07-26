import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { FeatureFlagScope } from '../constants/settings-enums.constants';

export class FeatureFlagResponseDto {
  @ApiProperty({ description: 'Flag unique key' })
  key: string;

  @ApiProperty({ description: 'Flag description' })
  description: string;

  @ApiProperty({ description: 'Is flag enabled?' })
  isEnabled: boolean;

  @ApiProperty({ description: 'Flag scope', enum: FeatureFlagScope })
  scope: FeatureFlagScope;

  @ApiProperty({ description: 'Rollout percentage' })
  rolloutPercentage: number;

  @ApiPropertyOptional({ description: 'Allowed user UUIDs' })
  allowedUserIds?: string[] | null;
}
