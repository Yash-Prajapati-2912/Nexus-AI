import { IAIMentorContext } from './ai-mentor-context.interface';
import { IAIMentorStructuredResponse } from './ai-mentor-response.interface';

/**
 * Strategy interface for AI Mentor Provider implementations.
 */
export interface IAIMentorProvider {
  readonly providerName: string;

  generateMentorResponse(
    prompt: string,
    context: IAIMentorContext,
  ): Promise<IAIMentorStructuredResponse>;
}
