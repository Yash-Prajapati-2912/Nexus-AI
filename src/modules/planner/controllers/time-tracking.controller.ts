import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { TimeTrackingService } from '../services/time-tracking.service';
import { CreateTimeLogDto } from '../dto/create-time-log.dto';
import { TimeLogQueryDto } from '../dto/time-log-query.dto';
import { TimeLogResponseDto } from '../dto/time-log-response.dto';

@ApiTags('Task Time Tracking')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/time-tracking')
export class TimeTrackingController {
  constructor(private readonly timeTrackingService: TimeTrackingService) {}

  @Post('log')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Log focus time spent on a task (manual or automatic)' })
  @ApiBody({ type: CreateTimeLogDto })
  @ApiResponse({
    status: 201,
    description: 'Time log recorded successfully',
    type: TimeLogResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async logTime(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateTimeLogDto,
  ): Promise<TimeLogResponseDto> {
    return this.timeTrackingService.logTime(userId, dto);
  }

  @Get('logs')
  @ApiOperation({ summary: 'Get list of recorded task time logs' })
  @ApiResponse({
    status: 200,
    description: 'Time logs list returned',
    type: [TimeLogResponseDto],
  })
  async getTimeLogs(
    @CurrentUser('id') userId: string,
    @Query() queryDto: TimeLogQueryDto,
  ): Promise<TimeLogResponseDto[]> {
    return this.timeTrackingService.getTimeLogs(userId, queryDto);
  }

  @Get('totals')
  @ApiOperation({ summary: 'Get aggregated study time totals (daily, weekly, monthly)' })
  @ApiQuery({ name: 'period', enum: ['daily', 'weekly', 'monthly'], required: false })
  @ApiResponse({
    status: 200,
    description: 'Aggregated totals returned',
  })
  async getAggregatedTotals(
    @CurrentUser('id') userId: string,
    @Query('period') period?: 'daily' | 'weekly' | 'monthly',
  ): Promise<{ period: string; totalMinutes: number; totalHours: number }> {
    return this.timeTrackingService.getAggregatedTotals(userId, period || 'daily');
  }
}
