import { Test, TestingModule } from '@nestjs/testing';
import { MediaController } from '../controllers/media.controller';
import { MediaService } from '../services/media.service';

describe('MediaController', () => {
  let controller: MediaController;

  const mockOwnerId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockService = {
      uploadFile: jest.fn().mockResolvedValue({ id: 'f-1', originalName: 'avatar.png', url: '/uploads/avatar.png' }),
      uploadMultipleFiles: jest.fn().mockResolvedValue([{ id: 'f-1', originalName: 'avatar.png' }]),
      getFileById: jest.fn().mockResolvedValue({ id: 'f-1', originalName: 'avatar.png' }),
      getUserFiles: jest.fn().mockResolvedValue({ files: [], total: 0 }),
      updateFile: jest.fn().mockResolvedValue({ id: 'f-1', folder: 'Updated' }),
      softDeleteFile: jest.fn().mockResolvedValue({ success: true }),
      restoreFile: jest.fn().mockResolvedValue({ success: true }),
      getFolders: jest.fn().mockResolvedValue([]),
      generateSignedUrl: jest.fn().mockResolvedValue({ signedUrl: '/signed-url' }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [MediaController],
      providers: [{ provide: MediaService, useValue: mockService }],
    }).compile();

    controller = module.get<MediaController>(MediaController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call uploadFile endpoint', async () => {
    const mockFile = { buffer: Buffer.from('abc'), originalname: 'avatar.png', mimetype: 'image/png' } as any;
    const res = await controller.uploadFile(mockOwnerId, mockFile, {});
    expect(res.originalName).toBe('avatar.png');
  });

  it('should call generateSignedUrl endpoint', async () => {
    const res = await controller.generateSignedUrl(mockOwnerId, 'f-1');
    expect(res.signedUrl).toBe('/signed-url');
  });
});
