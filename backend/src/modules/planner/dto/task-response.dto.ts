import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';
import { CategoryResponseDto } from './category-response.dto';
import { LabelResponseDto } from './label-response.dto';

export class TaskResponseDto {
  @ApiProperty({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Complete Linear Algebra Problem Set 3' })
  title: string;

  @ApiPropertyOptional({ example: 'Solve questions 1-10.', nullable: true })
  description: string | null;

  @ApiPropertyOptional({ example: 'c1c2c3c4-e5f6-7890-abcd-ef1234567890', nullable: true })
  categoryId: string | null;

  @ApiPropertyOptional({ type: () => CategoryResponseDto, nullable: true })
  categoryEntity?: CategoryResponseDto | null;

  @ApiPropertyOptional({ example: 'Assignments & Coursework', nullable: true })
  category: string | null;

  @ApiProperty({ enum: TaskPriority, example: TaskPriority.HIGH })
  priority: TaskPriority;

  @ApiProperty({ enum: TaskStatus, example: TaskStatus.TODO })
  status: TaskStatus;

  @ApiPropertyOptional({ example: 120, nullable: true })
  estimatedDurationMinutes: number | null;

  @ApiPropertyOptional({ example: 95, nullable: true })
  actualDurationMinutes: number | null;

  @ApiPropertyOptional({ example: '2026-07-26T09:00:00.000Z', nullable: true })
  startDate: Date | null;

  @ApiPropertyOptional({ example: '2026-07-28T23:59:59.000Z', nullable: true })
  dueDate: Date | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  completedAt: Date | null;

  @ApiProperty({ example: false })
  isPinned: boolean;

  @ApiProperty({ example: false })
  isArchived: boolean;

  @ApiProperty({ example: true })
  isImportant: boolean;

  @ApiPropertyOptional({ example: '#3B82F6', nullable: true })
  colour: string | null;

  @ApiPropertyOptional({ example: 'Review lecture notes first.', nullable: true })
  notes: string | null;

  @ApiPropertyOptional({ type: [LabelResponseDto] })
  labels?: LabelResponseDto[];

  @ApiPropertyOptional({ example: { source: 'manual' }, nullable: true })
  metadata: Record<string, any> | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
