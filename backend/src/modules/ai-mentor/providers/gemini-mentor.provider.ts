import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { IAIMentorProvider } from '../interfaces/ai-mentor-provider.interface';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';
import { IAIMentorStructuredResponse } from '../interfaces/ai-mentor-response.interface';

export type GeminiFailureCategory =
  | 'AUTH_FAILURE'
  | 'QUOTA_EXHAUSTED'
  | 'RATE_LIMITED_OR_OVERLOADED'
  | 'MODEL_UNAVAILABLE'
  | 'NETWORK_ERROR'
  | 'MALFORMED_RESPONSE'
  | 'UNKNOWN_ERROR';

@Injectable()
export class GeminiMentorProvider implements IAIMentorProvider {
  readonly providerName = 'GEMINI';
  private readonly logger = new Logger(GeminiMentorProvider.name);
  private genAI: GoogleGenerativeAI | null = null;
  private modelName: string;
  private lastFailureCategory: GeminiFailureCategory | null = null;
  private lastGenerationSuccessful = false;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('gemini.apiKey') || process.env.GEMINI_API_KEY;
    this.modelName =
      this.configService.get<string>('gemini.model') ||
      process.env.GEMINI_MODEL ||
      'gemini-3.5-flash-lite';
    if (apiKey && apiKey !== 'dev_gemini_api_key_placeholder') {
      this.genAI = new GoogleGenerativeAI(apiKey);
    }
  }

  getModelName(): string {
    return this.modelName;
  }

  getLastFailureCategory(): GeminiFailureCategory | null {
    return this.lastFailureCategory;
  }

  isLastGenerationSuccessful(): boolean {
    return this.lastGenerationSuccessful;
  }

  setGenerativeAIClient(client: GoogleGenerativeAI | null): void {
    this.genAI = client;
  }

  classifyError(err: any): GeminiFailureCategory {
    const msg = String(err?.message || '').toLowerCase();
    const status = err?.status || err?.statusCode || (err?.response && err?.response?.status);

    if (
      msg.includes('api_key_invalid') ||
      msg.includes('api key not valid') ||
      msg.includes('invalid api key') ||
      msg.includes('permission_denied') ||
      status === 401 ||
      status === 403
    ) {
      return 'AUTH_FAILURE';
    }
    if (
      msg.includes('resource_exhausted') ||
      msg.includes('quota') ||
      status === 429
    ) {
      return 'QUOTA_EXHAUSTED';
    }
    if (
      msg.includes('high demand') ||
      msg.includes('overloaded') ||
      msg.includes('unavailable') ||
      status === 503
    ) {
      return 'RATE_LIMITED_OR_OVERLOADED';
    }
    if (
      msg.includes('not found') ||
      msg.includes('no longer available') ||
      msg.includes('unsupported model') ||
      status === 404
    ) {
      return 'MODEL_UNAVAILABLE';
    }
    if (
      msg.includes('enotfound') ||
      msg.includes('etimedout') ||
      msg.includes('econnrefused') ||
      msg.includes('fetch failed') ||
      msg.includes('network') ||
      msg.includes('timeout')
    ) {
      return 'NETWORK_ERROR';
    }
    if (
      err instanceof SyntaxError ||
      msg.includes('json') ||
      msg.includes('unexpected token') ||
      msg.includes('is not valid json')
    ) {
      return 'MALFORMED_RESPONSE';
    }
    return 'UNKNOWN_ERROR';
  }

  async generateMentorResponse(
    prompt: string,
    context: IAIMentorContext,
  ): Promise<IAIMentorStructuredResponse> {
    const systemInstruction = `
You are the AI Personal Mentor for Nexus AI (Student Life Operating System).
Analyze student profile, education, skills, career goals, planner workload, finance metrics, and previous recommendations.
Output ONLY a valid raw JSON object matching this exact schema:
{
  "summary": "High-level executive mentoring summary",
  "reasoning": ["Point 1 of reasoning", "Point 2 of reasoning"],
  "recommendations": [
    {
      "title": "Recommendation Title",
      "description": "Detailed recommendation guidance",
      "priority": "HIGH",
      "domainCategory": "CAREER"
    }
  ],
  "actionPlan": [
    {
      "step": 1,
      "title": "Action title",
      "description": "Specific action guidance",
      "targetDeadlineDays": 3
    }
  ],
  "confidenceScore": 0.95,
  "followUpQuestions": ["Question 1?", "Question 2?"]
}
No markdown formatting blocks (\`\`\`json). Output clean raw JSON only.
`;

    if (!this.genAI) {
      this.lastFailureCategory = 'AUTH_FAILURE';
      this.lastGenerationSuccessful = false;
      this.logger.warn(
        JSON.stringify({
          event: 'GEMINI_PROVIDER_FALLBACK',
          category: 'AUTH_FAILURE',
          reason: 'API key is missing or unconfigured placeholder',
        }),
      );
      return this.getFallbackMentorResponse(context);
    }

    try {
      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const fullPrompt = `${systemInstruction}\n\n${prompt}`;
      const result = await model.generateContent(fullPrompt);
      const text = result?.response?.text ? result.response.text() : '';
      const cleaned = text.replace(/```json/g, '').replace(/```/g, '').trim();

      const parsed = JSON.parse(cleaned) as IAIMentorStructuredResponse;
      this.lastFailureCategory = null;
      this.lastGenerationSuccessful = true;
      this.logger.log(
        JSON.stringify({
          event: 'GEMINI_PROVIDER_SUCCESS',
          model: this.modelName,
        }),
      );

      return {
        summary: parsed.summary || 'AI Mentoring session processed.',
        reasoning: Array.isArray(parsed.reasoning) ? parsed.reasoning : [],
        recommendations: Array.isArray(parsed.recommendations) ? parsed.recommendations : [],
        actionPlan: Array.isArray(parsed.actionPlan) ? parsed.actionPlan : [],
        confidenceScore: typeof parsed.confidenceScore === 'number' ? parsed.confidenceScore : 0.9,
        followUpQuestions: Array.isArray(parsed.followUpQuestions) ? parsed.followUpQuestions : [],
      };
    } catch (err: any) {
      const category = this.classifyError(err);
      this.lastFailureCategory = category;
      this.lastGenerationSuccessful = false;
      this.logger.warn(
        JSON.stringify({
          event: 'GEMINI_PROVIDER_FALLBACK',
          category,
          model: this.modelName,
        }),
      );
      return this.getFallbackMentorResponse(context);
    }
  }

  private getFallbackMentorResponse(context: IAIMentorContext): IAIMentorStructuredResponse {
    const userGoal = context.userProfile?.careerGoals?.[0] || 'software engineering';
    const taskCount = context.plannerSummary?.totalActiveTasks || 0;

    return {
      summary: `Analyzed your student context including ${taskCount} active planner tasks and your career focus in ${userGoal}.`,
      reasoning: [
        `Prioritized high-impact tasks while keeping your primary goal in ${userGoal} aligned.`,
        'Balanced focus time to protect study quality and budget wellness.',
      ],
      recommendations: [
        {
          title: 'Schedule Deep Focus Block',
          description: 'Allocate 90 minutes of dedicated study time for upcoming academic milestones.',
          priority: 'HIGH',
          domainCategory: 'STUDY',
        },
      ],
      actionPlan: [
        {
          step: 1,
          title: 'Complete urgent assignment draft',
          description: 'Focus on high-priority task due within 48 hours.',
          targetDeadlineDays: 2,
        },
        {
          step: 2,
          title: 'Review weekly budget spending',
          description: 'Check category limits to maintain remaining monthly balance.',
          targetDeadlineDays: 4,
        },
      ],
      confidenceScore: 0.88,
      followUpQuestions: [
        'Would you like me to generate a structured 3-day study schedule for your upcoming exam?',
        'Should we review your monthly spending breakdown for potential savings?',
      ],
    };
  }
}
