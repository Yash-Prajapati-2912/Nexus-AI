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
import { FinancialAnalyticsService } from '../services/financial-analytics.service';
import { TrendAnalyticsService } from '../services/trend-analytics.service';
import { AnalyticsQueryDto } from '../dto/analytics-query.dto';
import { FinancialAnalyticsResponseDto } from '../dto/analytics-response.dto';
import { TrendResponseDto } from '../dto/trend-response.dto';

@ApiTags('Smart Finance - Analytics & Metrics')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/analytics')
export class FinancialAnalyticsController {
  constructor(
    private readonly analyticsService: FinancialAnalyticsService,
    private readonly trendService: TrendAnalyticsService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get aggregated financial analytics, category distributions, and metrics' })
  @ApiResponse({ status: 200, description: 'Analytics payload returned', type: FinancialAnalyticsResponseDto })
  async getAnalytics(
    @CurrentUser('id') userId: string,
    @Query() queryDto: AnalyticsQueryDto,
  ): Promise<FinancialAnalyticsResponseDto> {
    return this.analyticsService.getAnalytics(userId, queryDto);
  }

  @Get('trends')
  @ApiOperation({ summary: 'Get historical trend analysis (income, expense, savings growth)' })
  @ApiQuery({ name: 'periodType', required: false, description: 'MONTHLY or WEEKLY', example: 'MONTHLY' })
  @ApiQuery({ name: 'limit', required: false, description: 'Number of past periods to return', example: 6 })
  @ApiResponse({ status: 200, description: 'Trends payload returned', type: TrendResponseDto })
  async getTrends(
    @CurrentUser('id') userId: string,
    @Query('periodType') periodType?: string,
    @Query('limit') limit?: number,
  ): Promise<TrendResponseDto> {
    return this.trendService.getTrends(userId, periodType || 'MONTHLY', limit ? Number(limit) : 6);
  }
}
