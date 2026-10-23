import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import {
  ReminderRepeatType,
  ReminderDeliveryMethod,
} from '../constants/reminder-enums';

export class CreateReminderDto {
  @ApiProperty({ example: 'Review Chapter 5 for Midterm' })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({ example: 'Focus on linear transformations.' })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiPropertyOptional({ example: 't1t2t3t4-e5f6-7890-abcd-ef1234567890' })
  @IsOptional()
  @IsUUID('4')
  taskId?: string;

  @ApiProperty({ example: '2026-07-27T08:00:00.000Z' })
  @IsNotEmpty({ message: 'remindAt is required' })
  @IsDateString()
  remindAt: string;

  @ApiPropertyOptional({ enum: ReminderRepeatType, example: ReminderRepeatType.NONE })
  @IsOptional()
  @IsEnum(ReminderRepeatType)
  repeatType?: ReminderRepeatType;

  @ApiPropertyOptional({ enum: ReminderDeliveryMethod, example: ReminderDeliveryMethod.IN_APP })
  @IsOptional()
  @IsEnum(ReminderDeliveryMethod)
  deliveryMethod?: ReminderDeliveryMethod;
}
