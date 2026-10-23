import { Test, TestingModule } from '@nestjs/testing';
import { ProfileActivityService } from '../services/profile-activity.service';
import { ProfileActivityRepository } from '../repositories/profile-activity.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';
import { ProfileActivityType } from '../constants/activity-type.enum';

describe('ProfileActivityService', () => {
  let service: ProfileActivityService;
  let activityRepo: any;
  let profileRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    activityRepo = createMockRepository();
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileActivityService,
        { provide: ProfileActivityRepository, useValue: activityRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<ProfileActivityService>(ProfileActivityService);
  });

  describe('getActivityTimeline', () => {
    it('should return paginated activity entries', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);

      activityRepo.findByProfileIdPaginated.mockResolvedValue({
        data: [
          {
            id: 'act-1',
            profileId: mockProfile.id,
            activityType: ProfileActivityType.SKILL_ADDED,
            description: 'Added skill',
            createdAt: new Date(),
          },
        ],
        total: 1,
      });

      const result = await service.getActivityTimeline(mockUserId, 1, 10);

      expect(result.total).toBe(1);
      expect(result.data.length).toBe(1);
      expect(result.data[0].activityType).toBe(ProfileActivityType.SKILL_ADDED);
    });
  });
});
