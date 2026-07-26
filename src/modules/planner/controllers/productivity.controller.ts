import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ProductivityService } from '../services/productivity.service';
import { ProductivityMetricsResponseDto } from '../dto/productivity-metrics-response.dto';

@ApiTags('Planner Productivity Metrics')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/productivity')
export class ProductivityController {
  constructor(private readonly productivityService: ProductivityService) {}

  @Get()
  @ApiOperation({
    summary:
      'Get comprehensive productivity analytics (completed tasks/assignments, study hours, completion rate %, streak, missed deadlines)',
  })
  @ApiResponse({
    status: 200,
    description: 'Productivity metrics calculated successfully',
    type: ProductivityMetricsResponseDto,
  })
  async getProductivityMetrics(
    @CurrentUser('id') userId: string,
  ): Promise<ProductivityMetricsResponseDto> {
    return this.productivityService.getProductivityMetrics(userId);
  }
}
