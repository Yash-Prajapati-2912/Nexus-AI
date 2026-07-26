import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { RecurringTaskRepository } from '../repositories/recurring-task.repository';
import { TaskService } from './task.service';
import { CreateRecurringTaskDto } from '../dto/create-recurring-task.dto';
import { UpdateRecurringTaskDto } from '../dto/update-recurring-task.dto';
import { RecurringTaskResponseDto } from '../dto/recurring-task-response.dto';
import { RecurrencePattern } from '../constants/recurrence-enums';
import {
  RecurringTaskGeneratedEvent,
  PLANNER_EVENT_TOKENS,
} from '../events/planner-events';
import { RecurringTask } from '../entities/recurring-task.entity';

@Injectable()
export class RecurringTaskService {
  constructor(
    private readonly recurringRepository: RecurringTaskRepository,
    private readonly taskService: TaskService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createRecurringTask(
    userId: string,
    dto: CreateRecurringTaskDto,
  ): Promise<RecurringTaskResponseDto> {
    const startDate = new Date(dto.startDate);
    const nextOccurrenceAt = this.calculateNextOccurrence(
      startDate,
      dto.recurrencePattern,
      dto.intervalDays || 1,
    );

    const recurring = this.recurringRepository.create(
      {
        userId,
        taskId: dto.taskId || null,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        recurrencePattern: dto.recurrencePattern,
        intervalDays: dto.intervalDays || 1,
        dayOfWeek: dto.dayOfWeek ?? null,
        dayOfMonth: dto.dayOfMonth ?? null,
        startDate,
        endDate: dto.endDate ? new Date(dto.endDate) : null,
        maxOccurrences: dto.maxOccurrences ?? null,
        currentOccurrences: 0,
        isPaused: false,
        skipDates: dto.skipDates || null,
        nextOccurrenceAt,
      },
      userId,
    );

    const saved = await this.recurringRepository.save(recurring, userId);
    return this.toDto(saved);
  }

  async updateRecurringTask(
    userId: string,
    id: string,
    dto: UpdateRecurringTaskDto,
  ): Promise<RecurringTaskResponseDto> {
    const recurring = await this.recurringRepository.findById(id);
    if (!recurring) {
      throw new NotFoundException(`RecurringTask with ID ${id} not found.`);
    }

    if (recurring.userId !== userId) {
      throw new ForbiddenException('Access denied to requested recurring task.');
    }

    if (dto.title !== undefined) recurring.title = dto.title.trim();
    if (dto.description !== undefined) recurring.description = dto.description ? dto.description.trim() : null;
    if (dto.recurrencePattern !== undefined) recurring.recurrencePattern = dto.recurrencePattern;
    if (dto.intervalDays !== undefined) recurring.intervalDays = dto.intervalDays;
    if (dto.dayOfWeek !== undefined) recurring.dayOfWeek = dto.dayOfWeek;
    if (dto.dayOfMonth !== undefined) recurring.dayOfMonth = dto.dayOfMonth;
    if (dto.startDate !== undefined) recurring.startDate = new Date(dto.startDate);
    if (dto.endDate !== undefined) recurring.endDate = dto.endDate ? new Date(dto.endDate) : null;
    if (dto.maxOccurrences !== undefined) recurring.maxOccurrences = dto.maxOccurrences;
    if (dto.isPaused !== undefined) recurring.isPaused = dto.isPaused;
    if (dto.skipDates !== undefined) recurring.skipDates = dto.skipDates;

    const updated = await this.recurringRepository.save(recurring, userId);
    return this.toDto(updated);
  }

  async pauseRecurrence(userId: string, id: string): Promise<RecurringTaskResponseDto> {
    return this.updateRecurringTask(userId, id, { isPaused: true });
  }

  async resumeRecurrence(userId: string, id: string): Promise<RecurringTaskResponseDto> {
    return this.updateRecurringTask(userId, id, { isPaused: false });
  }

  async cancelRecurrence(userId: string, id: string): Promise<{ success: boolean }> {
    const recurring = await this.recurringRepository.findById(id);
    if (!recurring) {
      throw new NotFoundException(`RecurringTask with ID ${id} not found.`);
    }

    if (recurring.userId !== userId) {
      throw new ForbiddenException('Access denied to requested recurring task.');
    }

    await this.recurringRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async generateNextOccurrence(userId: string, id: string): Promise<RecurringTaskResponseDto> {
    const recurring = await this.recurringRepository.findById(id);
    if (!recurring) {
      throw new NotFoundException(`RecurringTask with ID ${id} not found.`);
    }

    if (recurring.userId !== userId) {
      throw new ForbiddenException('Access denied to requested recurring task.');
    }

    if (recurring.isPaused) {
      throw new BadRequestException('Cannot generate occurrence for paused recurring task.');
    }

    if (recurring.maxOccurrences && recurring.currentOccurrences >= recurring.maxOccurrences) {
      throw new BadRequestException('Maximum occurrence limit reached for this recurring task.');
    }

    const newTask = await this.taskService.createTask(userId, {
      title: recurring.title,
      description: recurring.description || undefined,
      dueDate: recurring.nextOccurrenceAt ? recurring.nextOccurrenceAt.toISOString() : new Date().toISOString(),
    });

    recurring.currentOccurrences += 1;
    const baseDate = recurring.nextOccurrenceAt || new Date();
    recurring.nextOccurrenceAt = this.calculateNextOccurrence(
      baseDate,
      recurring.recurrencePattern,
      recurring.intervalDays,
    );

    const updated = await this.recurringRepository.save(recurring, userId);

    this.eventEmitter.emit(
      PLANNER_EVENT_TOKENS.RECURRING_TASK_GENERATED,
      new RecurringTaskGeneratedEvent(recurring.id, newTask.id, userId),
    );

    return this.toDto(updated);
  }

  private calculateNextOccurrence(
    fromDate: Date,
    pattern: RecurrencePattern,
    intervalDays: number,
  ): Date {
    const next = new Date(fromDate);
    switch (pattern) {
      case RecurrencePattern.DAILY:
        next.setDate(next.getDate() + intervalDays);
        break;
      case RecurrencePattern.WEEKLY:
        next.setDate(next.getDate() + 7 * intervalDays);
        break;
      case RecurrencePattern.MONTHLY:
        next.setMonth(next.getMonth() + 1);
        break;
      case RecurrencePattern.YEARLY:
        next.setFullYear(next.getFullYear() + 1);
        break;
      case RecurrencePattern.CUSTOM:
      default:
        next.setDate(next.getDate() + intervalDays);
        break;
    }
    return next;
  }

  private toDto(entity: RecurringTask): RecurringTaskResponseDto {
    const dto = new RecurringTaskResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.taskId = entity.taskId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.recurrencePattern = entity.recurrencePattern;
    dto.intervalDays = entity.intervalDays;
    dto.dayOfWeek = entity.dayOfWeek;
    dto.dayOfMonth = entity.dayOfMonth;
    dto.startDate = entity.startDate;
    dto.endDate = entity.endDate;
    dto.maxOccurrences = entity.maxOccurrences;
    dto.currentOccurrences = entity.currentOccurrences;
    dto.isPaused = entity.isPaused;
    dto.skipDates = entity.skipDates;
    dto.nextOccurrenceAt = entity.nextOccurrenceAt;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }
}
