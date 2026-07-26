import { Reminder } from '../entities/reminder.entity';
import { ReminderResponseDto } from '../dto/reminder-response.dto';

export class ReminderMapper {
  static toDto(entity: Reminder): ReminderResponseDto {
    const dto = new ReminderResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.taskId = entity.taskId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.remindAt = entity.remindAt;
    dto.repeatType = entity.repeatType;
    dto.status = entity.status;
    dto.isSent = entity.isSent;
    dto.deliveryMethod = entity.deliveryMethod;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Reminder[]): ReminderResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
