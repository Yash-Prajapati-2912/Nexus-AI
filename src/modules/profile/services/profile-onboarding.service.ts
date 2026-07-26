import { Injectable, NotFoundException } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ProfileOnboardingRepository } from '../repositories/profile-onboarding.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { OnboardingStep } from '../constants/onboarding-step.enum';
import { CompleteOnboardingStepDto } from '../dto/complete-onboarding-step.dto';
import { OnboardingResponseDto } from '../dto/onboarding-response.dto';
import { OnboardingMapper } from '../mappers/onboarding.mapper';
import { OnboardingCompletedEvent, PROFILE_EVENT_TOKENS } from '../events/profile-events';

const ONBOARDING_STEP_ORDER: OnboardingStep[] = [
  OnboardingStep.WELCOME,
  OnboardingStep.PROFILE,
  OnboardingStep.EDUCATION,
  OnboardingStep.SKILLS,
  OnboardingStep.CAREER_GOAL,
  OnboardingStep.PREFERENCES,
  OnboardingStep.COMPLETED,
];

@Injectable()
export class ProfileOnboardingService {
  constructor(
    private readonly onboardingRepository: ProfileOnboardingRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getOnboardingStatus(userId: string): Promise<OnboardingResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    let onboarding = await this.onboardingRepository.findByProfileId(profile.id);
    if (!onboarding) {
      onboarding = await this.onboardingRepository.save(
        {
          profileId: profile.id,
          currentStep: OnboardingStep.WELCOME,
          completedSteps: [],
          isCompleted: false,
          progressPercentage: 0,
        },
        userId,
      );
    }

    return OnboardingMapper.toDto(onboarding);
  }

  async completeStep(
    userId: string,
    dto: CompleteOnboardingStepDto,
  ): Promise<OnboardingResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found.');
    }

    let onboarding = await this.onboardingRepository.findByProfileId(profile.id);
    if (!onboarding) {
      onboarding = this.onboardingRepository.create(
        {
          profileId: profile.id,
          currentStep: OnboardingStep.WELCOME,
          completedSteps: [],
          isCompleted: false,
          progressPercentage: 0,
        },
        userId,
      );
    }

    const stepToComplete = dto.step;
    const completedSet = new Set(onboarding.completedSteps || []);
    completedSet.add(stepToComplete);
    onboarding.completedSteps = Array.from(completedSet);

    // Calculate percentage based on completed steps out of total step sequence
    const totalStepsCount = ONBOARDING_STEP_ORDER.length - 1; // Excluding COMPLETED
    const completedCount = onboarding.completedSteps.length;
    const percentage = Math.min(100, Math.round((completedCount / totalStepsCount) * 100));
    onboarding.progressPercentage = percentage;

    // Advance currentStep to next step in sequence
    const stepIdx = ONBOARDING_STEP_ORDER.indexOf(stepToComplete);
    if (stepIdx >= 0 && stepIdx < ONBOARDING_STEP_ORDER.length - 1) {
      onboarding.currentStep = ONBOARDING_STEP_ORDER[stepIdx + 1];
    }

    if (
      onboarding.completedSteps.length >= totalStepsCount ||
      onboarding.currentStep === OnboardingStep.COMPLETED
    ) {
      onboarding.isCompleted = true;
      onboarding.currentStep = OnboardingStep.COMPLETED;
      onboarding.progressPercentage = 100;
      if (!onboarding.completedAt) {
        onboarding.completedAt = new Date();
      }

      this.eventEmitter.emit(
        PROFILE_EVENT_TOKENS.ONBOARDING_COMPLETED,
        new OnboardingCompletedEvent(profile.id, userId),
      );
    }

    const saved = await this.onboardingRepository.save(onboarding, userId);
    return OnboardingMapper.toDto(saved);
  }
}
