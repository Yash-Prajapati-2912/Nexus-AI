import { IAIPromptContext } from './ai-prompt-context.interface';
import { IAIStructuredResponse } from './ai-planning-result.interface';

export const AI_PROVIDER_TOKEN = 'AI_PROVIDER_TOKEN';

export interface IAIProvider {
  readonly providerName: string;
  generateStructuredPlanning(
    prompt: string,
    context: IAIPromptContext,
  ): Promise<IAIStructuredResponse>;
}
