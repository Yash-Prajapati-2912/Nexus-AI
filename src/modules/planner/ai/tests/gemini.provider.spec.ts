import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { GeminiProvider } from '../providers/gemini.provider';

describe('GeminiProvider', () => {
  let provider: GeminiProvider;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GeminiProvider,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue('dev_gemini_api_key_placeholder'),
          },
        },
      ],
    }).compile();

    provider = module.get<GeminiProvider>(GeminiProvider);
  });

  describe('generateStructuredPlanning', () => {
    it('should return valid structured response with fallback when in dev mode', async () => {
      const res = await provider.generateStructuredPlanning('Test prompt', {
        userId: 'u123',
        actionType: 'PRIORITISE_TASKS',
        tasks: [{ id: 't1', title: 'Math Homework' }],
      });

      expect(res.summary).toBeDefined();
      expect(res.recommendations).toBeDefined();
      expect(res.confidenceScore).toBeGreaterThan(0);
    });
  });
});
