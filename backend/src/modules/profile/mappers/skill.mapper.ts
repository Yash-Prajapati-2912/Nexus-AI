import { Skill } from '../entities/skill.entity';
import { SkillResponseDto } from '../dto/skill-response.dto';
import { IPublicSkill } from '../interfaces/public-profile.interface';

export class SkillMapper {
  static toDto(entity: Skill): SkillResponseDto {
    const dto = new SkillResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.name = entity.name;
    dto.category = entity.category;
    dto.level = entity.level;
    dto.yearsOfExperience = Number(entity.yearsOfExperience) || 0;
    dto.isVerified = entity.isVerified;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Skill[]): SkillResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }

  static toPublicDto(entity: Skill): IPublicSkill {
    return {
      name: entity.name,
      category: entity.category,
      level: entity.level,
      isVerified: entity.isVerified,
    };
  }

  static toPublicDtoList(entities: Skill[]): IPublicSkill[] {
    return (entities || []).map((entity) => this.toPublicDto(entity));
  }
}
