import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty } from 'class-validator';
import { OnboardingStep } from '../constants/onboarding-step.enum';

export class CompleteOnboardingStepDto {
  @ApiProperty({
    enum: OnboardingStep,
    description: 'Onboarding step to complete',
    example: OnboardingStep.EDUCATION,
  })
  @IsNotEmpty({ message: 'step is required' })
  @IsEnum(OnboardingStep)
  step: OnboardingStep;
}
