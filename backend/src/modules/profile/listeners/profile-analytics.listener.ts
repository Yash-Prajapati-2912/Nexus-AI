import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import {
  ProfileCreatedEvent,
  OnboardingCompletedEvent,
  PROFILE_EVENT_TOKENS,
} from '../events/profile-events';

@Injectable()
export class ProfileAnalyticsListener {
  private readonly logger = new Logger(ProfileAnalyticsListener.name);

  @OnEvent(PROFILE_EVENT_TOKENS.CREATED, { async: true })
  async handleAnalyticsOnProfileCreated(event: ProfileCreatedEvent): Promise<void> {
    this.logger.log(`[Analytics] Tracked new profile creation: ${event.profileId}`);
    // Future AI context refresh & analytics aggregation hook
  }

  @OnEvent(PROFILE_EVENT_TOKENS.ONBOARDING_COMPLETED, { async: true })
  async handleAnalyticsOnOnboardingCompleted(event: OnboardingCompletedEvent): Promise<void> {
    this.logger.log(`[Analytics] Tracked onboarding completion: ${event.profileId}`);
    // Future AI model personalisation hook
  }
}
