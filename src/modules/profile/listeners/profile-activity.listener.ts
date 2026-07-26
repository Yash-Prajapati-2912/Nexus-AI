import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import {
  ProfileCreatedEvent,
  ProfileUpdatedEvent,
  AvatarUploadedEvent,
  EducationAddedEvent,
  SkillAddedEvent,
  CareerGoalCreatedEvent,
  PreferenceUpdatedEvent,
  OnboardingCompletedEvent,
  PROFILE_EVENT_TOKENS,
} from '../events/profile-events';
import { ProfileActivityRepository } from '../repositories/profile-activity.repository';
import { ProfileActivityType } from '../constants/activity-type.enum';

@Injectable()
export class ProfileActivityListener {
  private readonly logger = new Logger(ProfileActivityListener.name);

  constructor(private readonly activityRepository: ProfileActivityRepository) {}

  @OnEvent(PROFILE_EVENT_TOKENS.CREATED, { async: true })
  async handleProfileCreated(event: ProfileCreatedEvent): Promise<void> {
    this.logger.log(`Handling ProfileCreatedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.PROFILE_CREATED,
      description: 'Profile created successfully.',
      metadata: event.metadata,
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.UPDATED, { async: true })
  async handleProfileUpdated(event: ProfileUpdatedEvent): Promise<void> {
    this.logger.log(`Handling ProfileUpdatedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.PROFILE_UPDATED,
      description: `Updated profile attributes: ${event.updatedFields.join(', ')}`,
      metadata: { fields: event.updatedFields },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.AVATAR_UPLOADED, { async: true })
  async handleAvatarUploaded(event: AvatarUploadedEvent): Promise<void> {
    this.logger.log(`Handling AvatarUploadedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.AVATAR_UPDATED,
      description: 'Uploaded new profile avatar.',
      metadata: { avatarUrl: event.avatarUrl },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.EDUCATION_ADDED, { async: true })
  async handleEducationAdded(event: EducationAddedEvent): Promise<void> {
    this.logger.log(`Handling EducationAddedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.EDUCATION_ADDED,
      description: `Added education: ${event.degree} at ${event.institution}`,
      metadata: { institution: event.institution, degree: event.degree },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.SKILL_ADDED, { async: true })
  async handleSkillAdded(event: SkillAddedEvent): Promise<void> {
    this.logger.log(`Handling SkillAddedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.SKILL_ADDED,
      description: `Added skill: ${event.skillName} (${event.level})`,
      metadata: { skillName: event.skillName, level: event.level },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.CAREER_GOAL_CREATED, { async: true })
  async handleCareerGoalCreated(event: CareerGoalCreatedEvent): Promise<void> {
    this.logger.log(`Handling CareerGoalCreatedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.CAREER_GOAL_ADDED,
      description: `Created career goal: ${event.title} in ${event.targetIndustry}`,
      metadata: { title: event.title, targetIndustry: event.targetIndustry },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.PREFERENCE_UPDATED, { async: true })
  async handlePreferenceUpdated(event: PreferenceUpdatedEvent): Promise<void> {
    this.logger.log(`Handling PreferenceUpdatedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.PREFERENCE_CHANGED,
      description: `Updated user preferences (${event.updatedKeys.join(', ')})`,
      metadata: { keys: event.updatedKeys },
    });
  }

  @OnEvent(PROFILE_EVENT_TOKENS.ONBOARDING_COMPLETED, { async: true })
  async handleOnboardingCompleted(event: OnboardingCompletedEvent): Promise<void> {
    this.logger.log(`Handling OnboardingCompletedEvent for profile ${event.profileId}`);
    await this.activityRepository.save({
      profileId: event.profileId,
      activityType: ProfileActivityType.ONBOARDING_COMPLETED,
      description: 'Completed overall student onboarding journey!',
      metadata: { completedAt: new Date() },
    });
  }
}
