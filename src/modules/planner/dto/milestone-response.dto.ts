import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MilestoneStatus } from '../constants/milestone-enums';

export class MilestoneResponseDto {
  @ApiProperty({ example: 'm1m2m3m4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Complete Operating Systems Final Project Phase 1' })
  title: string;

  @ApiPropertyOptional({ example: 'Implement thread synchronization primitive.', nullable: true })
  description: string | null;

  @ApiProperty({ example: '2026-08-10T23:59:59.000Z' })
  targetDate: Date;

  @ApiProperty({ enum: MilestoneStatus, example: MilestoneStatus.IN_PROGRESS })
  status: MilestoneStatus;

  @ApiProperty({ example: 45.0 })
  progressPercentage: number;

  @ApiPropertyOptional({ example: 'a1a2a3a4-e5f6-7890-abcd-ef1234567890', nullable: true })
  linkedAssignmentId: string | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
