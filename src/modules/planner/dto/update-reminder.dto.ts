import { PartialType, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { CreateReminderDto } from './create-reminder.dto';
import { ReminderStatus } from '../constants/reminder-enums';

export class UpdateReminderDto extends PartialType(CreateReminderDto) {
  @ApiPropertyOptional({ enum: ReminderStatus, example: ReminderStatus.PENDING })
  @IsOptional()
  @IsEnum(ReminderStatus)
  status?: ReminderStatus;
}
