import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ReminderRepeatType,
  ReminderStatus,
  ReminderDeliveryMethod,
} from '../constants/reminder-enums';

export class ReminderResponseDto {
  @ApiProperty({ example: 'r1r2r3r4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890', nullable: true })
  taskId: string | null;

  @ApiProperty({ example: 'Review Chapter 5 for Midterm' })
  title: string;

  @ApiPropertyOptional({ example: 'Focus on linear transformations.', nullable: true })
  description: string | null;

  @ApiProperty({ example: '2026-07-27T08:00:00.000Z' })
  remindAt: Date;

  @ApiProperty({ enum: ReminderRepeatType, example: ReminderRepeatType.NONE })
  repeatType: ReminderRepeatType;

  @ApiProperty({ enum: ReminderStatus, example: ReminderStatus.PENDING })
  status: ReminderStatus;

  @ApiProperty({ example: false })
  isSent: boolean;

  @ApiProperty({ enum: ReminderDeliveryMethod, example: ReminderDeliveryMethod.IN_APP })
  deliveryMethod: ReminderDeliveryMethod;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
