import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TaskPriority } from '../constants/task-priority.enum';
import { StudyPlanStatus } from '../constants/study-plan-enums';

export class StudyPlanResponseDto {
  @ApiProperty({ example: 'sp1sp2sp3-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Operating Systems & Kernel Concepts' })
  subject: string;

  @ApiPropertyOptional({ example: 'CS 140', nullable: true })
  course: string | null;

  @ApiProperty({ example: 40.0 })
  targetHours: number;

  @ApiProperty({ example: 12.5 })
  completedHours: number;

  @ApiProperty({ example: 31.25, description: 'Completion percentage (0-100%)' })
  completionPercentage: number;

  @ApiProperty({ example: '2026-08-01T00:00:00.000Z' })
  startDate: Date;

  @ApiProperty({ example: '2026-08-31T23:59:59.000Z' })
  endDate: Date;

  @ApiProperty({ enum: TaskPriority, example: TaskPriority.HIGH })
  priority: TaskPriority;

  @ApiProperty({ enum: StudyPlanStatus, example: StudyPlanStatus.ACTIVE })
  status: StudyPlanStatus;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
