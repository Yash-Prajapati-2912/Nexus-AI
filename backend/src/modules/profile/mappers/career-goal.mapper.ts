import { CareerGoal } from '../entities/career-goal.entity';
import { CareerGoalResponseDto } from '../dto/career-goal-response.dto';
import { IPublicCareerGoal } from '../interfaces/public-profile.interface';

export class CareerGoalMapper {
  static toDto(entity: CareerGoal): CareerGoalResponseDto {
    const dto = new CareerGoalResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.title = entity.title;
    dto.targetIndustry = entity.targetIndustry;
    dto.targetCompany = entity.targetCompany;
    dto.preferredLocation = entity.preferredLocation;
    dto.expectedSalary = entity.expectedSalary ? Number(entity.expectedSalary) : null;
    dto.targetYear = entity.targetYear;
    dto.notes = entity.notes;
    dto.isPrimary = entity.isPrimary;
    dto.status = entity.status;
    dto.progress = Number(entity.progress) || 0;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: CareerGoal[]): CareerGoalResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }

  static toPublicDto(entity: CareerGoal): IPublicCareerGoal {
    return {
      title: entity.title,
      targetIndustry: entity.targetIndustry,
      targetYear: entity.targetYear,
    };
  }

  static toPublicDtoList(entities: CareerGoal[]): IPublicCareerGoal[] {
    return (entities || []).map((entity) => this.toPublicDto(entity));
  }
}
