import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IAIProvider } from '../interfaces/ai-provider.interface';
import { GeminiProvider } from './gemini.provider';
import { AIProviderType } from '../constants/ai-planner.constants';

@Injectable()
export class AIProviderFactory {
  constructor(
    private readonly configService: ConfigService,
    private readonly geminiProvider: GeminiProvider,
  ) {}

  getProvider(providerType?: AIProviderType): IAIProvider {
    const selected =
      providerType ||
      (this.configService.get<string>('AI_PROVIDER') as AIProviderType) ||
      AIProviderType.GEMINI;

    switch (selected) {
      case AIProviderType.GEMINI:
      default:
        return this.geminiProvider;
    }
  }
}
