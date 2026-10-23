import { Test, TestingModule } from '@nestjs/testing';
import { ProfileAnalyticsService } from '../services/profile-analytics.service';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserDocumentRepository } from '../repositories/user-document.repository';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('ProfileAnalyticsService', () => {
  let service: ProfileAnalyticsService;
  let profileRepo: any;
  let docRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    profileRepo = createMockRepository();
    docRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileAnalyticsService,
        { provide: UserProfileRepository, useValue: profileRepo },
        { provide: UserDocumentRepository, useValue: docRepo },
      ],
    }).compile();

    service = module.get<ProfileAnalyticsService>(ProfileAnalyticsService);
  });

  describe('getProfileAnalytics', () => {
    it('should calculate resource counts and metrics correctly', async () => {
      const mockProfile = ProfileFactory.createMockProfile({
        userId: mockUserId,
        educationHistory: [ProfileFactory.createMockEducation()],
        skills: [ProfileFactory.createMockSkill(), ProfileFactory.createMockSkill({ id: 's2' })],
        careerGoals: [ProfileFactory.createMockCareerGoal()],
        documents: [],
      });

      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      docRepo.findPrimaryResume.mockResolvedValue({ id: 'doc-resume' });

      const res = await service.getProfileAnalytics(mockUserId);

      expect(res.educationCount).toBe(1);
      expect(res.skillCount).toBe(2);
      expect(res.careerGoalCount).toBe(1);
      expect(res.hasPrimaryResume).toBe(true);
    });
  });
});
