import { TaskTimeLog } from '../entities/task-time-log.entity';
import { TimeLogResponseDto } from '../dto/time-log-response.dto';

export class TimeLogMapper {
  static toDto(entity: TaskTimeLog): TimeLogResponseDto {
    const dto = new TimeLogResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.taskId = entity.taskId;
    dto.startTime = entity.startTime;
    dto.endTime = entity.endTime;
    dto.durationMinutes = entity.durationMinutes;
    dto.entryType = entity.entryType;
    dto.notes = entity.notes;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: TaskTimeLog[]): TimeLogResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
