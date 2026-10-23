import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CalendarEventResponseDto {
  @ApiProperty({ example: 'e1e2e3e4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Algorithms Lecture & Workshop' })
  title: string;

  @ApiPropertyOptional({ example: 'Room 302, Computer Science Building.', nullable: true })
  description: string | null;

  @ApiProperty({ example: '2026-07-27T10:00:00.000Z' })
  startTime: Date;

  @ApiProperty({ example: '2026-07-27T11:30:00.000Z' })
  endTime: Date;

  @ApiProperty({ example: false })
  isAllDay: boolean;

  @ApiPropertyOptional({ example: 'Hall B, Stanford Campus', nullable: true })
  location: string | null;

  @ApiProperty({ example: '#3B82F6' })
  colour: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890', nullable: true })
  linkedTaskId: string | null;

  @ApiPropertyOptional({ example: 'a1a2a3a4-e5f6-7890-abcd-ef1234567890', nullable: true })
  linkedAssignmentId: string | null;

  @ApiProperty({ example: 'America/Los_Angeles' })
  timezone: string;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
