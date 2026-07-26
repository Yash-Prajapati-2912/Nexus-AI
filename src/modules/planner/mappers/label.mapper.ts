import { TaskLabel } from '../entities/label.entity';
import { LabelResponseDto } from '../dto/label-response.dto';

export class LabelMapper {
  static toDto(entity: TaskLabel): LabelResponseDto {
    const dto = new LabelResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.name = entity.name;
    dto.colour = entity.colour;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: TaskLabel[]): LabelResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
