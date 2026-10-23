import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { OnboardingStep } from '../constants/onboarding-step.enum';

export class OnboardingResponseDto {
  @ApiProperty({ example: 'o1o2o3o4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  profileId: string;

  @ApiProperty({ enum: OnboardingStep, example: OnboardingStep.EDUCATION })
  currentStep: OnboardingStep;

  @ApiProperty({
    enum: OnboardingStep,
    isArray: true,
    example: [OnboardingStep.WELCOME, OnboardingStep.PROFILE, OnboardingStep.EDUCATION],
  })
  completedSteps: OnboardingStep[];

  @ApiProperty({ example: false })
  isCompleted: boolean;

  @ApiProperty({ example: 50.0 })
  progressPercentage: number;

  @ApiPropertyOptional({ example: null, nullable: true })
  completedAt: Date | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
