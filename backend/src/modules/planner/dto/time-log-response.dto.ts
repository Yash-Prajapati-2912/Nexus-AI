import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TimeLogEntryType } from '../constants/study-plan-enums';

export class TimeLogResponseDto {
  @ApiProperty({ example: 'tl1tl2tl3-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  taskId: string;

  @ApiProperty({ example: '2026-07-27T10:00:00.000Z' })
  startTime: Date;

  @ApiProperty({ example: '2026-07-27T11:45:00.000Z' })
  endTime: Date;

  @ApiProperty({ example: 105 })
  durationMinutes: number;

  @ApiProperty({ enum: TimeLogEntryType, example: TimeLogEntryType.MANUAL })
  entryType: TimeLogEntryType;

  @ApiPropertyOptional({ example: 'Logged focus time via manual stopwatch.', nullable: true })
  notes: string | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
