import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { EducationService } from '../services/education.service';
import { EducationRepository } from '../repositories/education.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('EducationService', () => {
  let service: EducationService;
  let educationRepo: any;
  let profileRepo: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    educationRepo = createMockRepository();
    profileRepo = createMockRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EducationService,
        ProfileCompletionService,
        { provide: EducationRepository, useValue: educationRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
      ],
    }).compile();

    service = module.get<EducationService>(EducationService);
  });

  describe('createEducation', () => {
    it('should create education record successfully', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);
      const mockEdu = ProfileFactory.createMockEducation({ profileId: mockProfile.id });
      educationRepo.save.mockResolvedValue(mockEdu);

      const result = await service.createEducation(mockUserId, {
        institution: 'Stanford University',
        degree: 'BS',
        fieldOfStudy: 'CS',
        startDate: '2022-09-01',
      });

      expect(result.institution).toBe('Stanford University');
    });

    it('should throw BadRequestException if endDate is earlier than startDate', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);

      await expect(
        service.createEducation(mockUserId, {
          institution: 'Stanford',
          degree: 'BS',
          fieldOfStudy: 'CS',
          startDate: '2025-01-01',
          endDate: '2020-01-01',
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
