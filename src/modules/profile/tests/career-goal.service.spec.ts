import { Test, TestingModule } from '@nestjs/testing';
import { CareerGoalService } from '../services/career-goal.service';
import { CareerGoalRepository } from '../repositories/career-goal.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('CareerGoalService', () => {
  let service: CareerGoalService;
  let goalRepo: any;
  let profileRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    goalRepo = createMockRepository();
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CareerGoalService,
        ProfileCompletionService,
        { provide: CareerGoalRepository, useValue: goalRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<CareerGoalService>(CareerGoalService);
  });

  describe('createCareerGoal', () => {
    it('should create goal and clear primary flags if set as primary', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);
      const mockGoal = ProfileFactory.createMockCareerGoal({ isPrimary: true });
      goalRepo.save.mockResolvedValue(mockGoal);

      const result = await service.createCareerGoal(mockUserId, {
        title: 'AI Engineer',
        targetIndustry: 'AI',
        targetYear: 2027,
        isPrimary: true,
      });

      expect(goalRepo.clearPrimaryFlagForProfile).toHaveBeenCalledWith(mockProfile.id);
      expect(result.isPrimary).toBe(true);
    });
  });
});
