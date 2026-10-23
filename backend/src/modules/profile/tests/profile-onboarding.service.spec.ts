import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ProfileOnboardingService } from '../services/profile-onboarding.service';
import { ProfileOnboardingRepository } from '../repositories/profile-onboarding.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';
import { OnboardingStep } from '../constants/onboarding-step.enum';

describe('ProfileOnboardingService', () => {
  let service: ProfileOnboardingService;
  let onboardingRepo: any;
  let profileRepo: any;
  let eventEmitter: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    onboardingRepo = createMockRepository();
    profileRepo = createMockRepository();

    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileOnboardingService,
        { provide: ProfileOnboardingRepository, useValue: onboardingRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<ProfileOnboardingService>(ProfileOnboardingService);
  });

  describe('completeStep', () => {
    it('should complete welcome step and advance onboarding progress', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);

      onboardingRepo.findByProfileId.mockResolvedValue({
        id: 'onb-123',
        profileId: mockProfile.id,
        currentStep: OnboardingStep.WELCOME,
        completedSteps: [],
        isCompleted: false,
        progressPercentage: 0,
      });

      onboardingRepo.save.mockImplementation((entity: any) => Promise.resolve(entity));

      const result = await service.completeStep(mockUserId, { step: OnboardingStep.WELCOME });

      expect(result.completedSteps).toContain(OnboardingStep.WELCOME);
      expect(result.currentStep).toBe(OnboardingStep.PROFILE);
    });
  });
});
