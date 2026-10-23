import { ProfileActivityType } from '../constants/activity-type.enum';

export class BaseProfileEvent {
  constructor(
    public readonly profileId: string,
    public readonly userId: string,
    public readonly timestamp: Date = new Date(),
  ) {}
}

export class ProfileCreatedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.PROFILE_CREATED;
  constructor(
    profileId: string,
    userId: string,
    public readonly metadata: Record<string, any> = {},
  ) {
    super(profileId, userId);
  }
}

export class ProfileUpdatedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.PROFILE_UPDATED;
  constructor(
    profileId: string,
    userId: string,
    public readonly updatedFields: string[],
  ) {
    super(profileId, userId);
  }
}

export class AvatarUploadedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.AVATAR_UPDATED;
  constructor(
    profileId: string,
    userId: string,
    public readonly avatarUrl: string,
  ) {
    super(profileId, userId);
  }
}

export class EducationAddedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.EDUCATION_ADDED;
  constructor(
    profileId: string,
    userId: string,
    public readonly institution: string,
    public readonly degree: string,
  ) {
    super(profileId, userId);
  }
}

export class SkillAddedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.SKILL_ADDED;
  constructor(
    profileId: string,
    userId: string,
    public readonly skillName: string,
    public readonly level: string,
  ) {
    super(profileId, userId);
  }
}

export class CareerGoalCreatedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.CAREER_GOAL_ADDED;
  constructor(
    profileId: string,
    userId: string,
    public readonly title: string,
    public readonly targetIndustry: string,
  ) {
    super(profileId, userId);
  }
}

export class PreferenceUpdatedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.PREFERENCE_CHANGED;
  constructor(
    profileId: string,
    userId: string,
    public readonly updatedKeys: string[],
  ) {
    super(profileId, userId);
  }
}

export class OnboardingCompletedEvent extends BaseProfileEvent {
  public readonly activityType = ProfileActivityType.ONBOARDING_COMPLETED;
  constructor(
    profileId: string,
    userId: string,
  ) {
    super(profileId, userId);
  }
}

export const PROFILE_EVENT_TOKENS = {
  CREATED: 'profile.created',
  UPDATED: 'profile.updated',
  AVATAR_UPLOADED: 'profile.avatar_uploaded',
  EDUCATION_ADDED: 'profile.education_added',
  SKILL_ADDED: 'profile.skill_added',
  CAREER_GOAL_CREATED: 'profile.career_goal_created',
  PREFERENCE_UPDATED: 'profile.preference_updated',
  ONBOARDING_COMPLETED: 'profile.onboarding_completed',
} as const;
