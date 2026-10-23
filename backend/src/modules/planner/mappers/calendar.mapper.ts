import { CalendarEvent } from '../entities/calendar-event.entity';
import { CalendarEventResponseDto } from '../dto/calendar-event-response.dto';

export class CalendarMapper {
  static toDto(entity: CalendarEvent): CalendarEventResponseDto {
    const dto = new CalendarEventResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.startTime = entity.startTime;
    dto.endTime = entity.endTime;
    dto.isAllDay = entity.isAllDay;
    dto.location = entity.location;
    dto.colour = entity.colour;
    dto.linkedTaskId = entity.linkedTaskId;
    dto.linkedAssignmentId = entity.linkedAssignmentId;
    dto.timezone = entity.timezone;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: CalendarEvent[]): CalendarEventResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
