import { ImageOptimiserService } from '../optimisers/image-optimiser.service';

describe('ImageOptimiserService', () => {
  let service: ImageOptimiserService;

  beforeEach(() => {
    service = new ImageOptimiserService();
  });

  it('should process and optimize image buffers', async () => {
    const dummyBuffer = Buffer.from('test-image-data');
    const result = await service.processAndOptimise(dummyBuffer, 'image/png');

    expect(result.optimisedBuffer).toBeDefined();
    expect(result.width).toBe(1280);
    expect(result.height).toBe(720);
  });
});
