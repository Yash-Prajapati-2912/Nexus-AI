import {
  Controller,
  Get,
  Post,
  UseGuards,
  HttpCode,
  HttpStatus,
  Query,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { DashboardService } from '../services/dashboard.service';
import { DashboardResponseDto } from '../dto/dashboard-response.dto';
import { ActivityTimelineResponseDto } from '../dto/activity-timeline-response.dto';
import { DashboardAnalyticsResponseDto } from '../dto/dashboard-analytics-response.dto';
import { AchievementResponseDto } from '../dto/achievement-response.dto';
import { UserInsightResponseDto } from '../dto/user-insight-response.dto';

@ApiTags('Dashboard & Analytics Platform')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get()
  @ApiOperation({ summary: 'Get Master Aggregated Dashboard Payload (Planner, Finance, Profile, Mentor)' })
  @ApiResponse({ status: 200, description: 'Master aggregated dashboard payload', type: DashboardResponseDto })
  async getDashboard(
    @CurrentUser('id') userId: string,
  ): Promise<DashboardResponseDto> {
    return this.dashboardService.getDashboard(userId);
  }

  @Get('widgets')
  @ApiOperation({ summary: 'Get Configured Active Dashboard Widgets' })
  @ApiResponse({ status: 200, description: 'Configured active dashboard widgets list' })
  async getWidgets(
    @CurrentUser('id') userId: string,
  ) {
    return this.dashboardService.getWidgets(userId);
  }

  @Get('activity')
  @ApiOperation({ summary: 'Get Consolidated Cross-Domain Activity Timeline Feed' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Max items to return' })
  @ApiResponse({ status: 200, description: 'Activity timeline feed', type: ActivityTimelineResponseDto })
  async getActivityTimeline(
    @CurrentUser('id') userId: string,
    @Query('limit') limit?: number,
  ): Promise<ActivityTimelineResponseDto> {
    return this.dashboardService.getActivityTimeline(userId, limit ? Number(limit) : 20);
  }

  @Get('analytics')
  @ApiOperation({ summary: 'Get Overall Productivity, Focus, and Wellness Analytics' })
  @ApiResponse({ status: 200, description: 'Dashboard analytics summary', type: DashboardAnalyticsResponseDto })
  async getAnalytics(
    @CurrentUser('id') userId: string,
  ): Promise<DashboardAnalyticsResponseDto> {
    return this.dashboardService.getAnalytics(userId);
  }

  @Get('achievements')
  @ApiOperation({ summary: 'Get Unlocked and Milestone Student Achievements' })
  @ApiResponse({ status: 200, description: 'Student achievements summary', type: AchievementResponseDto })
  async getAchievements(
    @CurrentUser('id') userId: string,
  ): Promise<AchievementResponseDto> {
    return this.dashboardService.getAchievements(userId);
  }

  @Get('insights')
  @ApiOperation({ summary: 'Get Personalised Daily, Weekly, and Monthly Insights & Priority Alerts' })
  @ApiResponse({ status: 200, description: 'Personalized user insights', type: UserInsightResponseDto })
  async getUserInsights(
    @CurrentUser('id') userId: string,
  ): Promise<UserInsightResponseDto> {
    return this.dashboardService.getUserInsights(userId);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Force Manual Refresh of Dashboard Cache & Snapshot' })
  @ApiResponse({ status: 200, description: 'Dashboard cache cleared and refreshed' })
  async refreshDashboard(
    @CurrentUser('id') userId: string,
  ): Promise<{ success: boolean; refreshedAt: Date }> {
    return this.dashboardService.refreshDashboard(userId);
  }
}
