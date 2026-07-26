import { UserPreference } from '../entities/user-preference.entity';
import { UserPreferenceResponseDto } from '../dto/user-preference-response.dto';

export class UserPreferenceMapper {
  static toDto(entity: UserPreference): UserPreferenceResponseDto {
    const dto = new UserPreferenceResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.theme = entity.theme;
    dto.language = entity.language;
    dto.notificationPreferences = entity.notificationPreferences;
    dto.studyPreferences = entity.studyPreferences;
    dto.reminderPreferences = entity.reminderPreferences;
    dto.aiPreferences = entity.aiPreferences;
    dto.privacySettings = entity.privacySettings;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }
}
