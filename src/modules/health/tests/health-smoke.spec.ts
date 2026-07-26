import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from '../health.controller';
import { HealthService } from '../health.service';

describe('Health & Production Smoke Test Suite', () => {
  let controller: HealthController;

  beforeEach(async () => {
    const mockHealthService = {
      checkHealth: jest.fn().mockResolvedValue({
        status: 'ok',
        info: { database: { status: 'up' }, memory_heap: { status: 'up' } },
        error: {},
        details: { database: { status: 'up' }, memory_heap: { status: 'up' } },
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [{ provide: HealthService, useValue: mockHealthService }],
    }).compile();

    controller = module.get<HealthController>(HealthController);
  });

  it('should pass system health probe check', async () => {
    const res = await controller.check();
    expect(res.status).toBe('ok');
    expect(res.details.database.status).toBe('up');
  });
});
