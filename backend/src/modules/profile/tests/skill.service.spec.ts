import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { SkillService } from '../services/skill.service';
import { SkillRepository } from '../repositories/skill.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('SkillService', () => {
  let service: SkillService;
  let skillRepo: any;
  let profileRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    skillRepo = createMockRepository();
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SkillService,
        ProfileCompletionService,
        { provide: SkillRepository, useValue: skillRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<SkillService>(SkillService);
  });

  describe('createSkill', () => {
    it('should create a new skill', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);
      skillRepo.findByNameAndProfileId.mockResolvedValue(null);
      const mockSkill = ProfileFactory.createMockSkill({ name: 'TypeScript' });
      skillRepo.save.mockResolvedValue(mockSkill);

      const result = await service.createSkill(mockUserId, { name: 'TypeScript' });
      expect(result.name).toBe('TypeScript');
    });

    it('should throw ConflictException if duplicate skill name exists', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      skillRepo.findByNameAndProfileId.mockResolvedValue(ProfileFactory.createMockSkill());

      await expect(
        service.createSkill(mockUserId, { name: 'TypeScript' }),
      ).rejects.toThrow(ConflictException);
    });
  });
});
