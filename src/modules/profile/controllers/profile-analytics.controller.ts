import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ProfileAnalyticsService } from '../services/profile-analytics.service';
import { ProfileAnalyticsResponseDto } from '../dto/profile-analytics-response.dto';

@ApiTags('Profile Analytics')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/analytics')
export class ProfileAnalyticsController {
  constructor(private readonly analyticsService: ProfileAnalyticsService) {}

  @Get()
  @ApiOperation({ summary: 'Get comprehensive profile completion & resource analytics' })
  @ApiResponse({
    status: 200,
    description: 'Profile analytics returned successfully',
    type: ProfileAnalyticsResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async getProfileAnalytics(
    @CurrentUser('id') userId: string,
  ): Promise<ProfileAnalyticsResponseDto> {
    return this.analyticsService.getProfileAnalytics(userId);
  }
}
