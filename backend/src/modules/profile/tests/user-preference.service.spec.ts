import { Test, TestingModule } from '@nestjs/testing';
import { UserPreferenceService } from '../services/user-preference.service';
import { UserPreferenceRepository } from '../repositories/user-preference.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';
import { ThemePreference } from '../constants/theme.enum';

describe('UserPreferenceService', () => {
  let service: UserPreferenceService;
  let prefRepo: any;
  let profileRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    prefRepo = createMockRepository();
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserPreferenceService,
        ProfileCompletionService,
        { provide: UserPreferenceRepository, useValue: prefRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<UserPreferenceService>(UserPreferenceService);
  });

  describe('updatePreferences', () => {
    it('should update theme and notification preferences', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);
      const mockPref = ProfileFactory.createMockPreference({ profileId: mockProfile.id });
      prefRepo.findByProfileId.mockResolvedValue(mockPref);
      prefRepo.save.mockResolvedValue({
        ...mockPref,
        theme: ThemePreference.DARK,
      });

      const result = await service.updatePreferences(mockUserId, {
        theme: ThemePreference.DARK,
      });

      expect(result.theme).toBe(ThemePreference.DARK);
    });
  });
});
