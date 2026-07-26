import {
  Controller,
  Get,
  Post,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseIntPipe,
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
import { MonthlySummaryService } from '../services/monthly-summary.service';
import { MonthlySummaryQueryDto } from '../dto/monthly-summary-query.dto';
import { MonthlySummaryResponseDto } from '../dto/monthly-summary-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';

@ApiTags('Smart Finance - Monthly Summary')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/summary')
export class MonthlySummaryController {
  constructor(private readonly summaryService: MonthlySummaryService) {}

  @Get()
  @ApiOperation({ summary: 'Get aggregated financial monthly summary' })
  @ApiResponse({ status: 200, description: 'Monthly summary returned', type: MonthlySummaryResponseDto })
  async getMonthlySummary(
    @CurrentUser('id') userId: string,
    @Query() queryDto: MonthlySummaryQueryDto,
  ): Promise<MonthlySummaryResponseDto> {
    return this.summaryService.getMonthlySummary(userId, queryDto);
  }

  @Post('recalculate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Force recalculation of monthly summary metrics' })
  @ApiQuery({ name: 'month', required: true, description: 'Month (1-12)' })
  @ApiQuery({ name: 'year', required: true, description: 'Year (2000-2100)' })
  @ApiResponse({ status: 200, description: 'Recalculated monthly summary returned', type: MonthlySummaryResponseDto })
  async recalculateSummary(
    @CurrentUser('id') userId: string,
    @Query('month', ParseIntPipe) month: number,
    @Query('year', ParseIntPipe) year: number,
  ): Promise<MonthlySummaryResponseDto> {
    const summary = await this.summaryService.recalculateSummary(userId, month, year);
    return FinanceMapper.toMonthlySummaryDto(summary);
  }
}
