import { Controller, Get, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { DashboardWidgetService } from '../services/dashboard-widget.service';
import { DashboardWidgetsResponseDto } from '../dto/dashboard-widget-response.dto';

@ApiTags('Smart Finance - Dashboard Widgets')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/widgets')
export class DashboardWidgetController {
  constructor(private readonly widgetService: DashboardWidgetService) {}

  @Get()
  @ApiOperation({ summary: 'Get UI dashboard-ready financial summary widgets' })
  @ApiResponse({ status: 200, description: 'Dashboard widgets returned', type: DashboardWidgetsResponseDto })
  async getDashboardWidgets(
    @CurrentUser('id') userId: string,
  ): Promise<DashboardWidgetsResponseDto> {
    return this.widgetService.getDashboardWidgets(userId);
  }
}
