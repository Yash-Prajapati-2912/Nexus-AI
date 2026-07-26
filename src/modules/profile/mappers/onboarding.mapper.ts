import { ProfileOnboarding } from '../entities/profile-onboarding.entity';
import { OnboardingResponseDto } from '../dto/onboarding-response.dto';

export class OnboardingMapper {
  static toDto(entity: ProfileOnboarding): OnboardingResponseDto {
    const dto = new OnboardingResponseDto();
    dto.id = entity.id;
    dto.profileId = entity.profileId;
    dto.currentStep = entity.currentStep;
    dto.completedSteps = entity.completedSteps || [];
    dto.isCompleted = entity.isCompleted;
    dto.progressPercentage = Number(entity.progressPercentage) || 0;
    dto.completedAt = entity.completedAt;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }
}
