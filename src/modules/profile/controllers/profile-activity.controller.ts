import { Controller, Get, Query, UseGuards } from '@nestjs/common';
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
import { ProfileActivityService } from '../services/profile-activity.service';
import { ActivityTimelineResponseDto } from '../dto/activity-timeline-response.dto';

@ApiTags('Profile Activity & Timeline')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/activity')
export class ProfileActivityController {
  constructor(private readonly activityService: ProfileActivityService) {}

  @Get()
  @ApiOperation({ summary: 'Get paginated audit activity timeline for logged-in user' })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'limit', required: false, example: 20 })
  @ApiResponse({
    status: 200,
    description: 'Paginated activity timeline list returned',
  })
  async getActivityTimeline(
    @CurrentUser('id') userId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ): Promise<{ data: ActivityTimelineResponseDto[]; total: number; page: number; limit: number }> {
    const pageNum = page ? Math.max(1, Number(page)) : 1;
    const limitNum = limit ? Math.max(1, Math.min(100, Number(limit))) : 20;
    return this.activityService.getActivityTimeline(userId, pageNum, limitNum);
  }
}
