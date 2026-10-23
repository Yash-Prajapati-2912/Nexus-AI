import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProfileActivityType } from '../constants/activity-type.enum';

export class ActivityTimelineResponseDto {
  @ApiProperty({ example: 'act1-b2c3-4567-8901-234567890123' })
  id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  profileId: string;

  @ApiProperty({ enum: ProfileActivityType, example: ProfileActivityType.SKILL_ADDED })
  activityType: ProfileActivityType;

  @ApiProperty({ example: 'Added new technical skill: TypeScript (Advanced)' })
  description: string;

  @ApiPropertyOptional({ example: { skillName: 'TypeScript', level: 'ADVANCED' } })
  metadata?: Record<string, any> | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;
}
