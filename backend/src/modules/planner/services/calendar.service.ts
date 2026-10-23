import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { CalendarEventRepository } from '../repositories/calendar-event.repository';
import { CreateCalendarEventDto } from '../dto/create-calendar-event.dto';
import { UpdateCalendarEventDto } from '../dto/update-calendar-event.dto';
import { CalendarQueryDto, CalendarViewMode } from '../dto/calendar-query.dto';
import { CalendarEventResponseDto } from '../dto/calendar-event-response.dto';
import { CalendarMapper } from '../mappers/calendar.mapper';
import {
  CalendarEventCreatedEvent,
  PLANNER_EVENT_TOKENS,
} from '../events/planner-events';

@Injectable()
export class CalendarService {
  constructor(
    private readonly calendarRepository: CalendarEventRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createEvent(
    userId: string,
    dto: CreateCalendarEventDto,
  ): Promise<CalendarEventResponseDto> {
    const startTime = new Date(dto.startTime);
    const endTime = new Date(dto.endTime);

    const conflicts = await this.calendarRepository.findConflictingEvents(
      userId,
      startTime,
      endTime,
    );

    if (conflicts.length > 0) {
      throw new ConflictException(
        `Calendar conflict detected with ${conflicts.length} existing event(s).`,
      );
    }

    const event = this.calendarRepository.create(
      {
        userId,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        startTime,
        endTime,
        isAllDay: dto.isAllDay ?? false,
        location: dto.location ? dto.location.trim() : null,
        colour: dto.colour || '#3B82F6',
        linkedTaskId: dto.linkedTaskId || null,
        linkedAssignmentId: dto.linkedAssignmentId || null,
        timezone: dto.timezone || 'UTC',
      },
      userId,
    );

    const saved = await this.calendarRepository.save(event, userId);

    this.eventEmitter.emit(
      PLANNER_EVENT_TOKENS.CALENDAR_EVENT_CREATED,
      new CalendarEventCreatedEvent(saved.id, userId, saved.startTime, saved.endTime),
    );

    return CalendarMapper.toDto(saved);
  }

  async getEvents(
    userId: string,
    queryDto: CalendarQueryDto,
  ): Promise<CalendarEventResponseDto[]> {
    let startDate: Date | undefined;
    let endDate: Date | undefined;

    if (queryDto.startDate && queryDto.endDate) {
      startDate = new Date(queryDto.startDate);
      endDate = new Date(queryDto.endDate);
    } else {
      const now = new Date();
      const viewMode = queryDto.viewMode || CalendarViewMode.WEEK;

      switch (viewMode) {
        case CalendarViewMode.DAY:
          startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
          endDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);
          break;
        case CalendarViewMode.WEEK:
          const dayOfWeek = now.getDay();
          startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() - dayOfWeek);
          endDate = new Date(startDate.getTime() + 7 * 24 * 60 * 60 * 1000 - 1);
          break;
        case CalendarViewMode.MONTH:
          startDate = new Date(now.getFullYear(), now.getMonth(), 1);
          endDate = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
          break;
        case CalendarViewMode.AGENDA:
        default:
          startDate = new Date();
          endDate = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);
          break;
      }
    }

    const events = await this.calendarRepository.findEventsInRange(
      userId,
      startDate,
      endDate,
      queryDto.search,
    );

    return CalendarMapper.toDtoList(events);
  }

  async updateEvent(
    userId: string,
    id: string,
    dto: UpdateCalendarEventDto,
  ): Promise<CalendarEventResponseDto> {
    const event = await this.calendarRepository.findById(id);
    if (!event) {
      throw new NotFoundException(`Calendar event with ID ${id} not found.`);
    }

    if (event.userId !== userId) {
      throw new ForbiddenException('Access denied to requested calendar event.');
    }

    const startTime = dto.startTime ? new Date(dto.startTime) : event.startTime;
    const endTime = dto.endTime ? new Date(dto.endTime) : event.endTime;

    if (dto.startTime || dto.endTime) {
      const conflicts = await this.calendarRepository.findConflictingEvents(
        userId,
        startTime,
        endTime,
        id,
      );
      if (conflicts.length > 0) {
        throw new ConflictException(`Calendar conflict detected with existing event.`);
      }
    }

    if (dto.title !== undefined) event.title = dto.title.trim();
    if (dto.description !== undefined) event.description = dto.description ? dto.description.trim() : null;
    event.startTime = startTime;
    event.endTime = endTime;
    if (dto.isAllDay !== undefined) event.isAllDay = dto.isAllDay;
    if (dto.location !== undefined) event.location = dto.location ? dto.location.trim() : null;
    if (dto.colour !== undefined) event.colour = dto.colour;
    if (dto.linkedTaskId !== undefined) event.linkedTaskId = dto.linkedTaskId || null;
    if (dto.linkedAssignmentId !== undefined) event.linkedAssignmentId = dto.linkedAssignmentId || null;
    if (dto.timezone !== undefined) event.timezone = dto.timezone;

    const updated = await this.calendarRepository.save(event, userId);
    return CalendarMapper.toDto(updated);
  }

  async deleteEvent(userId: string, id: string): Promise<{ success: boolean }> {
    const event = await this.calendarRepository.findById(id);
    if (!event) {
      throw new NotFoundException(`Calendar event with ID ${id} not found.`);
    }

    if (event.userId !== userId) {
      throw new ForbiddenException('Access denied to requested calendar event.');
    }

    await this.calendarRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
