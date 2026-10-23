import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ProfileUploadService } from '../services/profile-upload.service';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { UserDocumentRepository } from '../repositories/user-document.repository';
import { STORAGE_SERVICE_TOKEN } from '../interfaces/storage-service.interface';
import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';
import { createMockRepository } from './mocks/repository.mock';

describe('ProfileUploadService', () => {
  let service: ProfileUploadService;
  let profileRepo: any;
  let docRepo: any;
  let storageService: any;
  let eventEmitter: any;

  const mockUserId = 'user-uuid-1234';

  beforeEach(async () => {
    profileRepo = createMockRepository();
    docRepo = createMockRepository();

    storageService = {
      uploadFile: jest.fn().mockResolvedValue({
        url: 'http://res.cloudinary.com/test.jpg',
        secureUrl: 'https://res.cloudinary.com/test.jpg',
        publicId: 'nexus-ai/avatars/test123',
        format: 'jpg',
        bytes: 1024,
        resourceType: 'image',
      }),
      deleteFile: jest.fn().mockResolvedValue(true),
    };

    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfileUploadService,
        ProfileCompletionService,
        { provide: UserProfileRepository, useValue: profileRepo },
        { provide: UserDocumentRepository, useValue: docRepo },
        { provide: STORAGE_SERVICE_TOKEN, useValue: storageService },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<ProfileUploadService>(ProfileUploadService);
  });

  describe('uploadAvatar', () => {
    it('should upload avatar to storage and update profile avatar fields', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId, avatarPublicId: 'old_id' });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);

      const mockFile = {
        buffer: Buffer.from('test'),
        originalname: 'avatar.jpg',
        mimetype: 'image/jpeg',
        size: 1024,
      } as Express.Multer.File;

      const result = await service.uploadAvatar(mockUserId, mockFile);

      expect(storageService.deleteFile).toHaveBeenCalledWith('old_id', 'image');
      expect(storageService.uploadFile).toHaveBeenCalled();
      expect(result.avatarUrl).toBe('https://res.cloudinary.com/test.jpg');
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });

  describe('deleteAvatar', () => {
    it('should delete avatar from storage and reset profile avatar fields', async () => {
      const mockProfile = ProfileFactory.createMockProfile({ userId: mockUserId, avatarPublicId: 'current_id' });
      profileRepo.findByUserId.mockResolvedValue(mockProfile);
      profileRepo.findByProfileIdWithRelations.mockResolvedValue(mockProfile);

      const result = await service.deleteAvatar(mockUserId);

      expect(storageService.deleteFile).toHaveBeenCalledWith('current_id', 'image');
      expect(profileRepo.save).toHaveBeenCalled();
      expect(result.success).toBe(true);
    });
  });
});
