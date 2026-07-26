import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { StudySessionStatus } from '../constants/study-plan-enums';

export class StudySessionResponseDto {
  @ApiProperty({ example: 'ss1ss2ss3-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'sp1sp2sp3-e5f6-7890-abcd-ef1234567890' })
  studyPlanId: string;

  @ApiProperty({ example: '2026-07-27T14:00:00.000Z' })
  startTime: Date;

  @ApiPropertyOptional({ example: '2026-07-27T16:00:00.000Z', nullable: true })
  endTime: Date | null;

  @ApiProperty({ example: 120 })
  durationMinutes: number;

  @ApiProperty({ example: 15 })
  breakDurationMinutes: number;

  @ApiPropertyOptional({ example: 'Reviewed chapter 4 memory paging concepts.', nullable: true })
  notes: string | null;

  @ApiProperty({ enum: StudySessionStatus, example: StudySessionStatus.COMPLETED })
  completionStatus: StudySessionStatus;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
