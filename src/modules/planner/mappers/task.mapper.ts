import { Task } from '../entities/task.entity';
import { TaskResponseDto } from '../dto/task-response.dto';
import { CategoryMapper } from './category.mapper';
import { LabelMapper } from './label.mapper';

export class TaskMapper {
  static toDto(entity: Task): TaskResponseDto {
    const dto = new TaskResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.categoryId = entity.categoryId;
    dto.priority = entity.priority;
    dto.status = entity.status;
    dto.estimatedDurationMinutes = entity.estimatedDurationMinutes;
    dto.actualDurationMinutes = entity.actualDurationMinutes;
    dto.startDate = entity.startDate;
    dto.dueDate = entity.dueDate;
    dto.completedAt = entity.completedAt;
    dto.isPinned = entity.isPinned;
    dto.isArchived = entity.isArchived;
    dto.isImportant = entity.isImportant;
    dto.colour = entity.colour;
    dto.notes = entity.notes;
    dto.metadata = entity.metadata;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;

    dto.category = entity.category;

    if (entity.categoryEntity) {
      dto.categoryEntity = CategoryMapper.toDto(entity.categoryEntity);
    }

    if (entity.labelMappings && entity.labelMappings.length > 0) {
      dto.labels = entity.labelMappings
        .filter((mapping) => mapping.label)
        .map((mapping) => LabelMapper.toDto(mapping.label));
    } else {
      dto.labels = [];
    }

    return dto;
  }

  static toDtoList(entities: Task[]): TaskResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
