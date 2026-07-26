import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TaskPriority } from '../constants/task-priority.enum';
import { AssignmentStatus } from '../constants/assignment-status.enum';

export class AssignmentResponseDto {
  @ApiProperty({ example: 'a1a2a3a4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Operating Systems Kernel Module Lab' })
  title: string;

  @ApiPropertyOptional({ example: 'Implement custom process scheduler.', nullable: true })
  description: string | null;

  @ApiProperty({ example: 'Computer Systems Architecture' })
  subject: string;

  @ApiPropertyOptional({ example: 'CS 140', nullable: true })
  course: string | null;

  @ApiPropertyOptional({ example: 4, nullable: true })
  semester: number | null;

  @ApiProperty({ enum: TaskPriority, example: TaskPriority.HIGH })
  priority: TaskPriority;

  @ApiProperty({ enum: AssignmentStatus, example: AssignmentStatus.PENDING })
  status: AssignmentStatus;

  @ApiProperty({ example: '2026-08-05T23:59:59.000Z' })
  deadline: Date;

  @ApiPropertyOptional({ example: 'https://github.com/student/cs140-lab1', nullable: true })
  submissionLink: string | null;

  @ApiPropertyOptional({ example: 12.5, nullable: true })
  estimatedHours: number | null;

  @ApiPropertyOptional({ example: 94.5, nullable: true })
  obtainedMarks: number | null;

  @ApiPropertyOptional({ example: 100, nullable: true })
  totalMarks: number | null;

  @ApiPropertyOptional({ example: [{ name: 'spec.pdf', url: 'https://cdn.example.com/spec.pdf' }], nullable: true })
  attachments: Record<string, any>[] | null;

  @ApiProperty({ example: false })
  isArchived: boolean;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
