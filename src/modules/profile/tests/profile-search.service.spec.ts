import { Test, TestingModule } from '@nestjs/testing';
import { ProfileSearchService } from '../services/profile-search.service';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { createMockRepository } from './mocks/repository.mock';

describe('ProfileSearchService', () => {
  let service: ProfileSearchService;
  let profileRepo: any;

  beforeEach(async () => {
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileSearchService,
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<ProfileSearchService>(ProfileSearchService);
  });

  describe('searchPublicProfiles', () => {
    it('should query profiles with search parameters and return public profile dtos', async () => {
      const mockQueryBuilder: any = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
      };

      profileRepo.createQueryBuilder.mockReturnValue(mockQueryBuilder);

      const result = await service.searchPublicProfiles({
        university: 'Stanford',
        page: 1,
        limit: 10,
      });

      expect(profileRepo.createQueryBuilder).toHaveBeenCalled();
      expect(result.total).toBe(0);
      expect(result.data).toEqual([]);
    });
  });
});
