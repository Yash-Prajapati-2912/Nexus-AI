import { Category } from '../entities/category.entity';
import { CategoryResponseDto } from '../dto/category-response.dto';

export class CategoryMapper {
  static toDto(entity: Category): CategoryResponseDto {
    const dto = new CategoryResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.name = entity.name;
    dto.isDefault = entity.isDefault;
    dto.colour = entity.colour;
    dto.icon = entity.icon;
    dto.sortOrder = entity.sortOrder;
    dto.isVisible = entity.isVisible;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Category[]): CategoryResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
