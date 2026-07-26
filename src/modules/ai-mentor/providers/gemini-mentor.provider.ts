import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { IAIMentorProvider } from '../interfaces/ai-mentor-provider.interface';
import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';
import { IAIMentorStructuredResponse } from '../interfaces/ai-mentor-response.interface';

@Injectable()
export class GeminiMentorProvider implements IAIMentorProvider {
  readonly providerName = 'GEMINI';
  private readonly logger = new Logger(GeminiMentorProvider.name);
  private genAI: GoogleGenerativeAI | null = null;
  private modelName: string;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('gemini.apiKey') || process.env.GEMINI_API_KEY;
    this.modelName = this.configService.get<string>('gemini.model') || 'gemini-1.5-flash';
    if (apiKey && apiKey !== 'dev_gemini_api_key_placeholder') {
      this.genAI = new GoogleGenerativeAI(apiKey);
    }
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

    try {
      if (!this.genAI) return this.getFallbackMentorResponse(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const fullPrompt = `${systemInstruction}\n\n${prompt}`;
      const result = await model.generateContent(fullPrompt);
      const cleaned = result.response.text().replace(/```json/g, '').replace(/```/g, '').trim();

      const parsed = JSON.parse(cleaned) as IAIMentorStructuredResponse;
      return {
        summary: parsed.summary || 'AI Mentoring session processed.',
        reasoning: parsed.reasoning || [],
        recommendations: parsed.recommendations || [],
        actionPlan: parsed.actionPlan || [],
        confidenceScore: parsed.confidenceScore ?? 0.9,
        followUpQuestions: parsed.followUpQuestions || [],
      };
    } catch (err: any) {
      this.logger.error(`Gemini Mentor provider error: ${err.message}`, err.stack);
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
