import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { ProfileService } from '../services/profile.service';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserPreferenceRepository } from '../repositories/user-preference.repository';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('ProfileService', () => {
  let service: ProfileService;
  let profileRepo: any;
  let preferenceRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    profileRepo = createMockRepository();
    preferenceRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileService,
        ProfileCompletionService,
        { provide: UserProfileRepository, useValue: profileRepo },
        { provide: UserPreferenceRepository, useValue: preferenceRepo },
      ],
    }).compile();

    service = module.get<ProfileService>(ProfileService);
  });

  describe('createProfile', () => {
    it('should successfully create profile and default preferences', async () => {
      profileRepo.findByUserId.mockResolvedValue(null);
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.save.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);
      preferenceRepo.findByProfileId.mockResolvedValue(null);
      preferenceRepo.save.mockResolvedValue(ProfileFactory.createMockPreference());

      const result = await service.createProfile(mockUserId, {
        university: 'Stanford University',
      });

      expect(profileRepo.findByUserId).toHaveBeenCalledWith(mockUserId, []);
      expect(profileRepo.save).toHaveBeenCalled();
      expect(result.userId).toBe(mockUserId);
    });

    it('should throw ConflictException if profile already exists', async () => {
      profileRepo.findByUserId.mockResolvedValue(ProfileFactory.createMockProfile());

      await expect(
        service.createProfile(mockUserId, { university: 'Stanford' }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('getProfile', () => {
    it('should return profile if found', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);

      const result = await service.getProfile(mockUserId);
      expect(result.id).toBe(mockProfile.id);
    });

    it('should throw NotFoundException if profile does not exist', async () => {
      profileRepo.findByUserId.mockResolvedValue(null);

      await expect(service.getProfile(mockUserId)).rejects.toThrow(NotFoundException);
    });
  });

  describe('deleteProfile', () => {
    it('should soft delete profile', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);

      const result = await service.deleteProfile(mockUserId);
      expect(profileRepo.softDeleteById).toHaveBeenCalledWith(mockProfile.id, mockUserId);
      expect(result.success).toBe(true);
    });
  });
});
