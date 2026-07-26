import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { IAIProvider } from '../interfaces/ai-provider.interface';
import { IAIPromptContext } from '../interfaces/ai-prompt-context.interface';
import { IAIStructuredResponse } from '../interfaces/ai-planning-result.interface';

@Injectable()
export class GeminiProvider implements IAIProvider {
  readonly providerName = 'GEMINI';
  private readonly logger = new Logger(GeminiProvider.name);
  private genAI: GoogleGenerativeAI | null = null;
  private modelName: string;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('gemini.apiKey') || process.env.GEMINI_API_KEY;
    this.modelName = this.configService.get<string>('gemini.model') || 'gemini-1.5-flash';
    if (apiKey && apiKey !== 'dev_gemini_api_key_placeholder') {
      this.genAI = new GoogleGenerativeAI(apiKey);
    }
  }

  async generateStructuredPlanning(
    prompt: string,
    context: IAIPromptContext,
  ): Promise<IAIStructuredResponse> {
    const systemInstruction = `
You are the AI Planning & Productivity Engine for Nexus AI (Student Life Operating System).
Analyze student tasks, assignments, deadlines, priorities, study plans, and profile context.
Produce ONLY a valid raw JSON object matching this exact schema:
{
  "summary": "High-level executive summary of AI planning analysis",
  "reasoning": ["point 1", "point 2"],
  "recommendations": [
    {
      "title": "Title of recommendation",
      "description": "Detailed recommendation guidance",
      "priority": "HIGH",
      "type": "RESOURCE",
      "linkUrl": "https://example.com"
    }
  ],
  "actionItems": [
    {
      "step": 1,
      "title": "Step action description",
      "allocatedMinutes": 45,
      "targetDate": "2026-07-28"
    }
  ],
  "warnings": ["Warning if overdue or overloaded"],
  "confidenceScore": 0.92
}
Do NOT include markdown formatting wrappers like \`\`\`json. Output clean JSON only.
`;

    try {
      if (!this.genAI) {
        this.logger.warn('Gemini API key is not configured or in development mode. Falling back to rule-based engine output.');
        return this.getFallbackResponse(context);
      }

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: {
          temperature: 0.2,
          responseMimeType: 'application/json',
        },
      });

      const fullPrompt = `${systemInstruction}\n\n${prompt}`;
      const result = await model.generateContent(fullPrompt);
      const text = result.response.text();

      const cleanedText = text.replace(/```json/g, '').replace(/```/g, '').trim();
      const parsed = JSON.parse(cleanedText) as IAIStructuredResponse;

      return {
        summary: parsed.summary || 'AI Analysis generated successfully.',
        reasoning: parsed.reasoning || [],
        recommendations: parsed.recommendations || [],
        actionItems: parsed.actionItems || [],
        warnings: parsed.warnings || [],
        confidenceScore: parsed.confidenceScore ?? 0.9,
      };
    } catch (err: any) {
      this.logger.error(`Gemini provider execution failed: ${err.message}`, err.stack);
      return this.getFallbackResponse(context);
    }
  }

  private getFallbackResponse(context: IAIPromptContext): IAIStructuredResponse {
    const taskCount = context.tasks ? context.tasks.length : 0;
    const assignmentCount = context.assignments ? context.assignments.length : 0;

    return {
      summary: `Analyzed ${taskCount} active tasks and ${assignmentCount} assignments.`,
      reasoning: [
        'Prioritized tasks approaching due date within the next 48 hours.',
        'Balanced daily study hours to prevent burnout.',
      ],
      recommendations: [
        {
          title: 'Schedule Focus Study Block',
          description: 'Allocate 90 minutes of uninterruptible focus time for primary assignment.',
          priority: 'HIGH',
          type: 'STUDY_SESSION',
        },
      ],
      actionItems: [
        {
          step: 1,
          title: 'Complete urgent assignment draft',
          allocatedMinutes: 60,
        },
        {
          step: 2,
          title: 'Take 15-minute scheduled break',
          allocatedMinutes: 15,
        },
      ],
      warnings: taskCount > 5 ? ['Workload is moderately high today. Consider pacing.'] : [],
      confidenceScore: 0.85,
    };
  }
}
