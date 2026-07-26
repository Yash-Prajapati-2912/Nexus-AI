import { Education } from '../entities/education.entity';
import { EducationResponseDto } from '../dto/education-response.dto';
import { IPublicEducation } from '../interfaces/public-profile.interface';

export class EducationMapper {
  static toDto(entity: Education): EducationResponseDto {
    const dto = new EducationResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.institution = entity.institution;
    dto.degree = entity.degree;
    dto.fieldOfStudy = entity.fieldOfStudy;
    dto.startDate = entity.startDate;
    dto.endDate = entity.endDate;
    dto.isCurrent = entity.isCurrent;
    dto.grade = entity.grade;
    dto.description = entity.description;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Education[]): EducationResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }

  static toPublicDto(entity: Education): IPublicEducation {
    return {
      institution: entity.institution,
      degree: entity.degree,
      fieldOfStudy: entity.fieldOfStudy,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isCurrent: entity.isCurrent,
    };
  }

  static toPublicDtoList(entities: Education[]): IPublicEducation[] {
    return (entities || []).map((entity) => this.toPublicDto(entity));
  }
}
