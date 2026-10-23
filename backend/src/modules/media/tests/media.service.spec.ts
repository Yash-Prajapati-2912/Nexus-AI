import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MediaService } from '../services/media.service';
import { MediaFileRepository } from '../repositories/media-file.repository';
import { MediaFolderRepository } from '../repositories/media-folder.repository';
import { MediaVersionRepository } from '../repositories/media-version.repository';
import { MediaAccessLogRepository } from '../repositories/media-access-log.repository';
import { MediaUsageRepository } from '../repositories/media-usage.repository';
import { StorageProviderFactory } from '../factories/storage-provider.factory';
import { ImageOptimiserService } from '../optimisers/image-optimiser.service';
import { MediaCacheService } from '../services/media-cache.service';
import { MediaQueueProcessor } from '../queues/media.queue';
import { StorageProviderType, MediaVisibility, MediaStatus } from '../constants/media-enums.constants';

describe('MediaService', () => {
  let service: MediaService;

  const mockOwnerId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockFileRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'f-1', status: MediaStatus.READY, createdAt: new Date() })),
      save: jest.fn().mockImplementation((e) => Promise.resolve(e)),
      findById: jest.fn().mockResolvedValue({ id: 'f-1', ownerId: mockOwnerId, visibility: MediaVisibility.PUBLIC, provider: StorageProviderType.LOCAL, storedName: 'f-1.png' }),
      findUserFiles: jest.fn().mockResolvedValue({ data: [], total: 0 }),
      softDeleteById: jest.fn().mockResolvedValue(true),
      restore: jest.fn().mockResolvedValue(true),
    };

    const mockFolderRepo = { findUserFolders: jest.fn().mockResolvedValue([]) };
    const mockVersionRepo = { save: jest.fn() };
    const mockLogRepo = { save: jest.fn() };
    const mockUsageRepo = { save: jest.fn() };

    const mockProvider = {
      upload: jest.fn().mockResolvedValue({ storedName: 'file-1.png', url: '/uploads/file-1.png', provider: StorageProviderType.LOCAL, size: 1024 }),
      delete: jest.fn().mockResolvedValue(true),
      generateSignedUrl: jest.fn().mockResolvedValue('/signed-url-abc'),
    };

    const mockProviderFactory = { getProvider: jest.fn().mockReturnValue(mockProvider) };
    const mockOptimiser = { processAndOptimise: jest.fn().mockResolvedValue({ optimisedBuffer: Buffer.from('opt'), width: 800, height: 600 }) };
    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined), invalidateUserMedia: jest.fn().mockResolvedValue(undefined) };
    const mockQueue = { addOptimisationJob: jest.fn().mockResolvedValue({ jobId: 'j-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MediaService,
        { provide: MediaFileRepository, useValue: mockFileRepo },
        { provide: MediaFolderRepository, useValue: mockFolderRepo },
        { provide: MediaVersionRepository, useValue: mockVersionRepo },
        { provide: MediaAccessLogRepository, useValue: mockLogRepo },
        { provide: MediaUsageRepository, useValue: mockUsageRepo },
        { provide: StorageProviderFactory, useValue: mockProviderFactory },
        { provide: ImageOptimiserService, useValue: mockOptimiser },
        { provide: MediaCacheService, useValue: mockCache },
        { provide: MediaQueueProcessor, useValue: mockQueue },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<MediaService>(MediaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should upload a single image file', async () => {
    const buffer = Buffer.from('image-binary');
    const res = await service.uploadFile(mockOwnerId, buffer, 'avatar.png', 'image/png', {});

    expect(res.originalName).toBe('avatar.png');
    expect(res.url).toBe('/uploads/file-1.png');
  });

  it('should generate signed url', async () => {
    const res = await service.generateSignedUrl(mockOwnerId, 'f-1');
    expect(res.signedUrl).toBe('/signed-url-abc');
  });
});
