import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { CashFlowService } from '../services/cash-flow.service';
import { CashFlowQueryDto } from '../dto/cash-flow-query.dto';
import { CashFlowResponseDto } from '../dto/cash-flow-response.dto';

@ApiTags('Smart Finance - Cash Flow')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/cash-flow')
export class CashFlowController {
  constructor(private readonly cashFlowService: CashFlowService) {}

  @Get()
  @ApiOperation({ summary: 'Get cash flow summary, daily averages, and projected balance' })
  @ApiResponse({ status: 200, description: 'Cash flow payload returned', type: CashFlowResponseDto })
  async getCashFlow(
    @CurrentUser('id') userId: string,
    @Query() queryDto: CashFlowQueryDto,
  ): Promise<CashFlowResponseDto> {
    return this.cashFlowService.getCashFlow(userId, queryDto);
  }
}
