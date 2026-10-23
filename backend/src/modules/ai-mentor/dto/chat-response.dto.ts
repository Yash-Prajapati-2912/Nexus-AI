import { ApiProperty } from '@nestjs/swagger';

export class RecommendationCardDto {
  @ApiProperty({ description: 'Recommendation title' })
  title: string;

  @ApiProperty({ description: 'Detailed guidance' })
  description: string;

  @ApiProperty({ description: 'Priority level', example: 'HIGH' })
  priority: string;

  @ApiProperty({ description: 'Domain category', example: 'CAREER' })
  domainCategory?: string;
}

export class ActionStepDto {
  @ApiProperty({ description: 'Step index number' })
  step: number;

  @ApiProperty({ description: 'Action step title' })
  title: string;

  @ApiProperty({ description: 'Action step detailed description' })
  description: string;

  @ApiProperty({ description: 'Target completion days horizon', example: 3 })
  targetDeadlineDays?: number;
}

export class ChatResponseDto {
  @ApiProperty({ description: 'Conversation UUID' })
  conversationId: string;

  @ApiProperty({ description: 'Message turn UUID' })
  messageId: string;

  @ApiProperty({ description: 'Executive Mentoring Summary' })
  summary: string;

  @ApiProperty({ description: 'Reasoning points', type: [String] })
  reasoning: string[];

  @ApiProperty({ description: 'Actionable recommendations', type: [RecommendationCardDto] })
  recommendations: RecommendationCardDto[];

  @ApiProperty({ description: 'Step-by-step action plan', type: [ActionStepDto] })
  actionPlan: ActionStepDto[];

  @ApiProperty({ description: 'Model confidence score' })
  confidenceScore: number;

  @ApiProperty({ description: 'Follow-up questions', type: [String] })
  followUpQuestions: string[];

  @ApiProperty({ description: 'Provider used' })
  providerName: string;
}
