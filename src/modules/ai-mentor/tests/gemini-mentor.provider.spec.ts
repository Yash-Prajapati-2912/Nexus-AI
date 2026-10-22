import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { Logger } from '@nestjs/common';
import { GeminiMentorProvider } from '../providers/gemini-mentor.provider';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';

describe('GeminiMentorProvider', () => {
  let provider: GeminiMentorProvider;
  let warnSpy: jest.SpyInstance;
  let logSpy: jest.SpyInstance;

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
    warnSpy = jest.spyOn(Logger.prototype, 'warn').mockImplementation(() => {});
    logSpy = jest.spyOn(Logger.prototype, 'log').mockImplementation(() => {});

    const mockConfig = {
      get: jest.fn().mockImplementation((key: string) => {
        if (key === 'gemini.apiKey') return 'dev_gemini_api_key_placeholder';
        if (key === 'gemini.model') return 'gemini-3.5-flash-lite';
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

  afterEach(() => {
    warnSpy.mockRestore();
    logSpy.mockRestore();
  });

  it('should be defined with correct providerName', () => {
    expect(provider).toBeDefined();
    expect(provider.providerName).toBe('GEMINI');
  });

  it('should use the configured model name', () => {
    expect(provider.getModelName()).toBe('gemini-3.5-flash-lite');
  });

  it('should generate fallback mentor response and record AUTH_FAILURE when API key is placeholder', async () => {
    const res = await provider.generateMentorResponse('test prompt', mockContext);

    expect(res.summary).toBeDefined();
    expect(res.recommendations.length).toBeGreaterThan(0);
    expect(res.actionPlan.length).toBeGreaterThan(0);
    expect(res.confidenceScore).toBe(0.88);
    expect(res.followUpQuestions.length).toBeGreaterThan(0);

    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('AUTH_FAILURE');

    // Confirm safe structured log without leaking secrets
    expect(warnSpy).toHaveBeenCalledWith(
      expect.stringContaining('"category":"AUTH_FAILURE"'),
    );
  });

  it('should parse a successful Gemini SDK response into expected structured response', async () => {
    const mockStructuredData = {
      summary: 'Live AI generated summary for software engineering track.',
      reasoning: ['Live reasoning 1', 'Live reasoning 2'],
      recommendations: [
        {
          title: 'Master TypeScript AST',
          description: 'Focus on compilers and AST manipulation',
          priority: 'HIGH',
          domainCategory: 'CAREER',
        },
      ],
      actionPlan: [
        {
          step: 1,
          title: 'Build custom lint rule',
          description: 'Create an AST transform step',
          targetDeadlineDays: 2,
        },
      ],
      confidenceScore: 0.96,
      followUpQuestions: ['Ready to dive into compiler design?'],
    };

    const mockModel = {
      generateContent: jest.fn().mockResolvedValue({
        response: {
          text: () => JSON.stringify(mockStructuredData),
        },
      }),
    };

    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };

    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('career prompt', mockContext);

    expect(mockGenAI.getGenerativeModel).toHaveBeenCalledWith({
      model: 'gemini-3.5-flash-lite',
      generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
    });
    expect(res.summary).toBe(mockStructuredData.summary);
    expect(res.reasoning).toEqual(mockStructuredData.reasoning);
    expect(res.recommendations).toHaveLength(1);
    expect(res.actionPlan).toHaveLength(1);
    expect(res.confidenceScore).toBe(0.96);
    expect(res.followUpQuestions).toHaveLength(1);

    expect(provider.isLastGenerationSuccessful()).toBe(true);
    expect(provider.getLastFailureCategory()).toBeNull();
    expect(logSpy).toHaveBeenCalledWith(
      expect.stringContaining('"event":"GEMINI_PROVIDER_SUCCESS"'),
    );
  });

  it('should handle API_KEY_INVALID error, record AUTH_FAILURE, and activate fallback safely', async () => {
    const mockModel = {
      generateContent: jest.fn().mockRejectedValue(
        new Error('[GoogleGenerativeAI Error]: [400 Bad Request] API_KEY_INVALID'),
      ),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.summary).toContain('Software Engineer');
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('AUTH_FAILURE');
    expect(warnSpy).toHaveBeenCalledWith(
      expect.stringContaining('"category":"AUTH_FAILURE"'),
    );
  });

  it('should handle RESOURCE_EXHAUSTED quota error, record QUOTA_EXHAUSTED, and activate fallback', async () => {
    const mockModel = {
      generateContent: jest.fn().mockRejectedValue(
        new Error('[429 Too Many Requests] RESOURCE_EXHAUSTED quota exceeded'),
      ),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.recommendations.length).toBeGreaterThan(0);
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('QUOTA_EXHAUSTED');
  });

  it('should handle 503 high demand error, record RATE_LIMITED_OR_OVERLOADED, and activate fallback', async () => {
    const mockModel = {
      generateContent: jest.fn().mockRejectedValue(
        new Error('[503 Service Unavailable] This model is currently experiencing high demand'),
      ),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.actionPlan.length).toBeGreaterThan(0);
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('RATE_LIMITED_OR_OVERLOADED');
  });

  it('should handle model 404 error, record MODEL_UNAVAILABLE, and activate fallback', async () => {
    const mockModel = {
      generateContent: jest.fn().mockRejectedValue(
        new Error('[404 Not Found] models/gemini-1.5-flash is not found for API version v1beta'),
      ),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.confidenceScore).toBe(0.88);
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('MODEL_UNAVAILABLE');
  });

  it('should handle network timeout/failure, record NETWORK_ERROR, and activate fallback', async () => {
    const mockModel = {
      generateContent: jest.fn().mockRejectedValue(
        new Error('TypeError: fetch failed (ETIMEDOUT)'),
      ),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.summary).toBeDefined();
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('NETWORK_ERROR');
  });

  it('should handle malformed JSON response, record MALFORMED_RESPONSE, and activate fallback', async () => {
    const mockModel = {
      generateContent: jest.fn().mockResolvedValue({
        response: {
          text: () => 'Invalid JSON non-structured output',
        },
      }),
    };
    const mockGenAI: any = {
      getGenerativeModel: jest.fn().mockReturnValue(mockModel),
    };
    provider.setGenerativeAIClient(mockGenAI);

    const res = await provider.generateMentorResponse('test', mockContext);

    expect(res.summary).toBeDefined();
    expect(provider.isLastGenerationSuccessful()).toBe(false);
    expect(provider.getLastFailureCategory()).toBe('MALFORMED_RESPONSE');
  });
});
