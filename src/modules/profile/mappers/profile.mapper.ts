import { UserProfile } from '../entities/user-profile.entity';
import { ProfileResponseDto } from '../dto/profile-response.dto';
import { IPublicProfile } from '../interfaces/public-profile.interface';
import { EducationMapper } from './education.mapper';
import { SkillMapper } from './skill.mapper';
import { CareerGoalMapper } from './career-goal.mapper';
import { UserPreferenceMapper } from './user-preference.mapper';

export class ProfileMapper {
  static toDto(entity: UserProfile): ProfileResponseDto {
    const dto = new ProfileResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.avatar = entity.avatar;
    dto.bio = entity.bio;
    dto.dateOfBirth = entity.dateOfBirth;
    dto.gender = entity.gender;
    dto.phone = entity.phone;
    dto.country = entity.country;
    dto.state = entity.state;
    dto.city = entity.city;
    dto.university = entity.university;
    dto.degree = entity.degree;
    dto.department = entity.department;
    dto.semester = entity.semester;
    dto.graduationYear = entity.graduationYear;
    dto.currentStatus = entity.currentStatus;
    dto.profileCompletionPercentage = Number(entity.profileCompletionPercentage) || 0;
    dto.timezone = entity.timezone;
    dto.language = entity.language;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;

    if (entity.educationHistory) {
      dto.educationHistory = EducationMapper.toDtoList(entity.educationHistory);
    }
    if (entity.skills) {
      dto.skills = SkillMapper.toDtoList(entity.skills);
    }
    if (entity.careerGoals) {
      dto.careerGoals = CareerGoalMapper.toDtoList(entity.careerGoals);
    }
    if (entity.preferences) {
      dto.preferences = UserPreferenceMapper.toDto(entity.preferences);
    }

    return dto;
  }

  static toPublicProfile(entity: UserProfile): IPublicProfile {
    const privacy = entity.preferences?.privacySettings;

    const publicProfile: IPublicProfile = {
      id: entity.id,
      avatar: entity.avatar,
      bio: entity.bio,
      country: entity.country,
      state: entity.state,
      city: entity.city,
      university: entity.university,
      degree: entity.degree,
      department: entity.department,
      currentStatus: entity.currentStatus,
    };

    if (privacy?.showEducation && entity.educationHistory) {
      publicProfile.education = EducationMapper.toPublicDtoList(entity.educationHistory);
    }

    if (privacy?.showSkills && entity.skills) {
      publicProfile.skills = SkillMapper.toPublicDtoList(entity.skills);
    }

    if (privacy?.showCareerGoals && entity.careerGoals) {
      publicProfile.careerGoals = CareerGoalMapper.toPublicDtoList(entity.careerGoals);
    }

    return publicProfile;
  }
}
