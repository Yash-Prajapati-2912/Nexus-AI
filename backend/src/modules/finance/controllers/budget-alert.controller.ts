import {
  Controller,
  Get,
  Patch,
  Param,
  Query,
  UseGuards,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { BudgetAlertService } from '../services/budget-alert.service';
import { BudgetAlertQueryDto } from '../dto/budget-alert-query.dto';
import { BudgetAlertResponseDto } from '../dto/budget-alert-response.dto';

@ApiTags('Smart Finance - Budget Alerts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/alerts')
export class BudgetAlertController {
  constructor(private readonly alertService: BudgetAlertService) {}

  @Get()
  @ApiOperation({ summary: 'Get budget and savings threshold alerts for user' })
  @ApiResponse({ status: 200, description: 'Alerts list returned', type: [BudgetAlertResponseDto] })
  async getUserAlerts(
    @CurrentUser('id') userId: string,
    @Query() queryDto: BudgetAlertQueryDto,
  ): Promise<BudgetAlertResponseDto[]> {
    return this.alertService.getUserAlerts(userId, queryDto);
  }

  @Patch(':id/read')
  @ApiOperation({ summary: 'Mark budget alert as read' })
  @ApiParam({ name: 'id', description: 'Alert UUID' })
  @ApiResponse({ status: 200, description: 'Alert marked as read', type: BudgetAlertResponseDto })
  async markAlertAsRead(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<BudgetAlertResponseDto> {
    return this.alertService.markAlertAsRead(userId, id);
  }
}
