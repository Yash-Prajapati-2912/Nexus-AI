import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IAIFinanceProvider } from '../interfaces/ai-finance-provider.interface';
import { GeminiFinanceProvider } from './gemini-finance.provider';
import { AIProviderType } from '../constants/finance-ai-enums.constants';

@Injectable()
export class AIFinanceProviderFactory {
  private readonly logger = new Logger(AIFinanceProviderFactory.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly geminiProvider: GeminiFinanceProvider,
  ) {}

  getProvider(providerType?: AIProviderType): IAIFinanceProvider {
    const activeType =
      providerType ||
      (this.configService.get<string>('AI_FINANCE_PROVIDER') as AIProviderType) ||
      AIProviderType.GEMINI;

    switch (activeType) {
      case AIProviderType.GEMINI:
        return this.geminiProvider;
      case AIProviderType.OPENAI:
      case AIProviderType.ANTHROPIC:
      case AIProviderType.LOCAL:
      default:
        this.logger.log(`Provider ${activeType} falling back to Gemini default provider.`);
        return this.geminiProvider;
    }
  }
}
