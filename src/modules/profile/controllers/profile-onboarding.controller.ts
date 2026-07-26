import { Controller, Get, Patch, Body, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ProfileOnboardingService } from '../services/profile-onboarding.service';
import { CompleteOnboardingStepDto } from '../dto/complete-onboarding-step.dto';
import { OnboardingResponseDto } from '../dto/onboarding-response.dto';

@ApiTags('Profile Onboarding')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/onboarding')
export class ProfileOnboardingController {
  constructor(private readonly onboardingService: ProfileOnboardingService) {}

  @Get()
  @ApiOperation({ summary: 'Get current student onboarding status and progress percentage' })
  @ApiResponse({
    status: 200,
    description: 'Onboarding status returned successfully',
    type: OnboardingResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async getOnboardingStatus(
    @CurrentUser('id') userId: string,
  ): Promise<OnboardingResponseDto> {
    return this.onboardingService.getOnboardingStatus(userId);
  }

  @Patch('step')
  @ApiOperation({ summary: 'Complete an onboarding step and advance journey progress' })
  @ApiBody({ type: CompleteOnboardingStepDto })
  @ApiResponse({
    status: 200,
    description: 'Onboarding step marked as completed',
    type: OnboardingResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async completeStep(
    @CurrentUser('id') userId: string,
    @Body() dto: CompleteOnboardingStepDto,
  ): Promise<OnboardingResponseDto> {
    return this.onboardingService.completeStep(userId, dto);
  }
}
