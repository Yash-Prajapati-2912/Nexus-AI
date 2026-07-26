import { ProfileActivity } from '../entities/profile-activity.entity';
import { ActivityTimelineResponseDto } from '../dto/activity-timeline-response.dto';

export class ActivityMapper {
  static toDto(entity: ProfileActivity): ActivityTimelineResponseDto {
    const dto = new ActivityTimelineResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.activityType = entity.activityType;
    dto.description = entity.description;
    dto.metadata = entity.metadata;
    dto.createdAt = entity.createdAt;
    return dto;
  }

  static toDtoList(entities: ProfileActivity[]): ActivityTimelineResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
