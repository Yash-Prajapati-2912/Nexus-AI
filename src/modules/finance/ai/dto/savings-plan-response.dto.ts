import { ApiProperty } from '@nestjs/swagger';

export class ActionStepDto {
  @ApiProperty({ description: 'Step index number' })
  step: number;

  @ApiProperty({ description: 'Action step title' })
  title: string;

  @ApiProperty({ description: 'Action step detailed description' })
  description: string;
}

export class SavingsPlanResponseDto {
  @ApiProperty({ description: 'Savings Strategy Plan Title' })
  title: string;

  @ApiProperty({ description: 'High level AI strategy' })
  strategy: string;

  @ApiProperty({ description: 'Suggested monthly savings deposit contribution' })
  suggestedMonthlyContribution: number;

  @ApiProperty({ description: 'Target categories to optimize or reduce', type: [String] })
  targetCategoriesToCut: string[];

  @ApiProperty({ description: 'Emergency fund advice' })
  emergencyFundAdvice: string;

  @ApiProperty({ description: 'Ordered action steps', type: [ActionStepDto] })
  actionSteps: ActionStepDto[];

  @ApiProperty({ description: 'Confidence score' })
  confidenceScore: number;
}
