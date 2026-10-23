import { ApiProperty } from '@nestjs/swagger';

export class DecisionAnalysisResponseDto {
  @ApiProperty({ description: 'Decision title statement' })
  decisionTitle: string;

  @ApiProperty({ description: 'Pros list', type: [String] })
  pros: string[];

  @ApiProperty({ description: 'Cons list', type: [String] })
  cons: string[];

  @ApiProperty({ description: 'Opportunity cost breakdown' })
  opportunityCost: string;

  @ApiProperty({ description: 'Risk assessment' })
  riskAssessment: string;

  @ApiProperty({ description: 'Long-term impact analysis' })
  longTermImpact: string;

  @ApiProperty({ description: 'Alternative suggestions', type: [String] })
  alternativeSuggestions: string[];

  @ApiProperty({ description: 'Model confidence score' })
  confidenceScore: number;
}
