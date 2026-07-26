import { Milestone } from '../entities/milestone.entity';
import { MilestoneResponseDto } from '../dto/milestone-response.dto';

export class MilestoneMapper {
  static toDto(entity: Milestone): MilestoneResponseDto {
    const dto = new MilestoneResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.targetDate = entity.targetDate;
    dto.status = entity.status;
    dto.progressPercentage = Number(entity.progressPercentage) || 0;
    dto.linkedAssignmentId = entity.linkedAssignmentId;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Milestone[]): MilestoneResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
