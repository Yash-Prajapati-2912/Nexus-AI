import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ProfileAnalyticsResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  profileId: string;

  @ApiProperty({ example: 85.0 })
  profileCompletionPercentage: number;

  @ApiProperty({ example: true })
  hasAvatar: boolean;

  @ApiPropertyOptional({ example: 'https://res.cloudinary.com/avatar.jpg', nullable: true })
  avatarUrl: string | null;

  @ApiProperty({ example: 2 })
  educationCount: number;

  @ApiProperty({ example: 6 })
  skillCount: number;

  @ApiProperty({ example: 2 })
  careerGoalCount: number;

  @ApiProperty({ example: 3 })
  documentsUploadedCount: number;

  @ApiProperty({ example: true })
  hasPrimaryResume: boolean;

  @ApiProperty({ example: 42 })
  accountAgeDays: number;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  lastProfileUpdateAt: Date;
}
