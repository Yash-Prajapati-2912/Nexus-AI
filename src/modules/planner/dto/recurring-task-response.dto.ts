import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { RecurrencePattern } from '../constants/recurrence-enums';

export class RecurringTaskResponseDto {
  @ApiProperty({ example: 'rt1rt2rt3-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890', nullable: true })
  taskId: string | null;

  @ApiProperty({ example: 'Weekly Lab Report Submission' })
  title: string;

  @ApiPropertyOptional({ example: 'Draft lab notes.', nullable: true })
  description: string | null;

  @ApiProperty({ enum: RecurrencePattern, example: RecurrencePattern.WEEKLY })
  recurrencePattern: RecurrencePattern;

  @ApiProperty({ example: 1 })
  intervalDays: number;

  @ApiPropertyOptional({ example: 1, nullable: true })
  dayOfWeek: number | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  dayOfMonth: number | null;

  @ApiProperty({ example: '2026-07-26T00:00:00.000Z' })
  startDate: Date;

  @ApiPropertyOptional({ example: '2026-12-31T23:59:59.000Z', nullable: true })
  endDate: Date | null;

  @ApiPropertyOptional({ example: 10, nullable: true })
  maxOccurrences: number | null;

  @ApiProperty({ example: 2 })
  currentOccurrences: number;

  @ApiProperty({ example: false })
  isPaused: boolean;

  @ApiPropertyOptional({ example: ['2026-08-15'], nullable: true })
  skipDates: string[] | null;

  @ApiPropertyOptional({ example: '2026-08-02T00:00:00.000Z', nullable: true })
  nextOccurrenceAt: Date | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
