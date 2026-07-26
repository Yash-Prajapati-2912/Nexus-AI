import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { GeminiMentorProvider } from '../providers/gemini-mentor.provider';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';

describe('GeminiMentorProvider', () => {
  let provider: GeminiMentorProvider;

  const mockContext: IAIMentorContext = {
    userId: '11111111-1111-1111-1111-111111111111',
    userProfile: {
      fullName: 'Alex Student',
      careerGoals: ['Software Engineer'],
    },
    plannerSummary: {
      totalActiveTasks: 5,
      urgentAssignmentsCount: 1,
      upcomingDeadlines: [{ title: 'Midterm', dueDate: '2026-07-28', priority: 'HIGH' }],
    },
  };

  beforeEach(async () => {
    const mockConfig = {
      get: jest.fn().mockImplementation((key: string) => {
        if (key === 'gemini.apiKey') return 'dev_gemini_api_key_placeholder';
        if (key === 'gemini.model') return 'gemini-1.5-flash';
        return null;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GeminiMentorProvider,
        { provide: ConfigService, useValue: mockConfig },
      ],
    }).compile();

    provider = module.get<GeminiMentorProvider>(GeminiMentorProvider);
  });

  it('should be defined', () => {
    expect(provider).toBeDefined();
    expect(provider.providerName).toBe('GEMINI');
  });

  it('should generate fallback mentor response when API key is in dev mode', async () => {
    const res = await provider.generateMentorResponse('test prompt', mockContext);

    expect(res.summary).toBeDefined();
    expect(res.recommendations.length).toBeGreaterThan(0);
    expect(res.actionPlan.length).toBeGreaterThan(0);
    expect(res.confidenceScore).toBe(0.88);
    expect(res.followUpQuestions.length).toBeGreaterThan(0);
  });
});
