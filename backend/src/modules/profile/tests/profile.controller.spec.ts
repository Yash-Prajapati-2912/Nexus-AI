import { Test, TestingModule } from '@nestjs/testing';
import { ProfileController } from '../controllers/profile.controller';
import { ProfileService } from '../services/profile.service';
import { ProfileFactory } from './factories/profile.factory';

describe('ProfileController', () => {
  let controller: ProfileController;
  let service: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    service = {
      createProfile: jest.fn(),
      getProfile: jest.fn(),
      getPublicProfile: jest.fn(),
      updateProfile: jest.fn(),
      deleteProfile: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [ProfileController],
      providers: [{ provide: ProfileService, useValue: service }],
    }).compile();

    controller = module.get<ProfileController>(ProfileController);
  });

  it('should call profileService.createProfile', async () => {
    const mockDto = { university: 'Stanford' };
    const mockProfileDto = ProfileFactory.createMockProfile() as any;
    service.createProfile.mockResolvedValue(mockProfileDto);

    const res = await controller.createProfile(mockUserId, mockDto);
    expect(service.createProfile).toHaveBeenCalledWith(mockUserId, mockDto);
    expect(res).toBe(mockProfileDto);
  });

  it('should call profileService.getProfile', async () => {
    const mockProfileDto = ProfileFactory.createMockProfile() as any;
    service.getProfile.mockResolvedValue(mockProfileDto);

    const res = await controller.getMyProfile(mockUserId);
    expect(service.getProfile).toHaveBeenCalledWith(mockUserId);
    expect(res).toBe(mockProfileDto);
  });
});
