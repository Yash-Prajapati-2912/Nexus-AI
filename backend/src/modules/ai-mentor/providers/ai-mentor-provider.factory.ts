import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IAIMentorProvider } from '../interfaces/ai-mentor-provider.interface';
import { GeminiMentorProvider } from './gemini-mentor.provider';
import { MentorProviderType } from '../constants/mentor-enums.constants';

@Injectable()
export class AIMentorProviderFactory {
  private readonly logger = new Logger(AIMentorProviderFactory.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly geminiProvider: GeminiMentorProvider,
  ) {}

  getProvider(providerType?: MentorProviderType): IAIMentorProvider {
    const activeType =
      providerType ||
      (this.configService.get<string>('AI_MENTOR_PROVIDER') as MentorProviderType) ||
      MentorProviderType.GEMINI;

    switch (activeType) {
      case MentorProviderType.GEMINI:
        return this.geminiProvider;
      case MentorProviderType.OPENAI:
      case MentorProviderType.CLAUDE:
      case MentorProviderType.LOCAL:
      default:
        this.logger.log(`Provider ${activeType} falling back to default Gemini mentor provider.`);
        return this.geminiProvider;
    }
  }
}
