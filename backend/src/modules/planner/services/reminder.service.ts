import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ReminderRepository } from '../repositories/reminder.repository';
import { CreateReminderDto } from '../dto/create-reminder.dto';
import { UpdateReminderDto } from '../dto/update-reminder.dto';
import { ReminderResponseDto } from '../dto/reminder-response.dto';
import { ReminderMapper } from '../mappers/reminder.mapper';
import { ReminderRepeatType, ReminderStatus, ReminderDeliveryMethod } from '../constants/reminder-enums';
import {
  ReminderCreatedEvent,
  ReminderCompletedEvent,
  PLANNER_EVENT_TOKENS,
} from '../events/planner-events';

@Injectable()
export class ReminderService {
  constructor(
    private readonly reminderRepository: ReminderRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createReminder(
    userId: string,
    dto: CreateReminderDto,
  ): Promise<ReminderResponseDto> {
    const remindAt = new Date(dto.remindAt);

    const reminder = this.reminderRepository.create(
      {
        userId,
        taskId: dto.taskId || null,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        remindAt,
        repeatType: dto.repeatType || ReminderRepeatType.NONE,
        status: ReminderStatus.PENDING,
        isSent: false,
        deliveryMethod: dto.deliveryMethod || ReminderDeliveryMethod.IN_APP,
      },
      userId,
    );

    const saved = await this.reminderRepository.save(reminder, userId);

    this.eventEmitter.emit(
      PLANNER_EVENT_TOKENS.REMINDER_CREATED,
      new ReminderCreatedEvent(saved.id, userId, saved.remindAt),
    );

    return ReminderMapper.toDto(saved);
  }

  async getUpcomingReminders(
    userId: string,
    limit: number = 20,
  ): Promise<ReminderResponseDto[]> {
    const reminders = await this.reminderRepository.findUpcomingForUser(userId, limit);
    return ReminderMapper.toDtoList(reminders);
  }

  async updateReminder(
    userId: string,
    id: string,
    dto: UpdateReminderDto,
  ): Promise<ReminderResponseDto> {
    const reminder = await this.reminderRepository.findById(id);
    if (!reminder) {
      throw new NotFoundException(`Reminder with ID ${id} not found.`);
    }

    if (reminder.userId !== userId) {
      throw new ForbiddenException('Access denied to requested reminder.');
    }

    if (dto.title !== undefined) reminder.title = dto.title.trim();
    if (dto.description !== undefined) reminder.description = dto.description ? dto.description.trim() : null;
    if (dto.taskId !== undefined) reminder.taskId = dto.taskId || null;
    if (dto.remindAt !== undefined) reminder.remindAt = new Date(dto.remindAt);
    if (dto.repeatType !== undefined) reminder.repeatType = dto.repeatType;
    if (dto.deliveryMethod !== undefined) reminder.deliveryMethod = dto.deliveryMethod;

    if (dto.status !== undefined) {
      reminder.status = dto.status;
      if (dto.status === ReminderStatus.SENT) {
        reminder.isSent = true;
        this.eventEmitter.emit(
          PLANNER_EVENT_TOKENS.REMINDER_COMPLETED,
          new ReminderCompletedEvent(reminder.id, userId),
        );
      }
    }

    const updated = await this.reminderRepository.save(reminder, userId);
    return ReminderMapper.toDto(updated);
  }

  async deleteReminder(userId: string, id: string): Promise<{ success: boolean }> {
    const reminder = await this.reminderRepository.findById(id);
    if (!reminder) {
      throw new NotFoundException(`Reminder with ID ${id} not found.`);
    }

    if (reminder.userId !== userId) {
      throw new ForbiddenException('Access denied to requested reminder.');
    }

    await this.reminderRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
