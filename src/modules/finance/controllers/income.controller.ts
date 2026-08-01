import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { IncomeService } from '../services/income.service';
import { CreateIncomeDto } from '../dto/create-income.dto';
import { UpdateIncomeDto } from '../dto/update-income.dto';
import { QueryIncomeDto } from '../dto/query-income.dto';
import { IncomeResponseDto } from '../dto/income-response.dto';

@ApiTags('Smart Finance - Income')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller(['finance/income', 'finance/incomes'])
export class IncomeController {
  constructor(private readonly incomeService: IncomeService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Log new income entry' })
  @ApiBody({ type: CreateIncomeDto })
  @ApiResponse({ status: 201, description: 'Income created successfully', type: IncomeResponseDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createIncome(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateIncomeDto,
  ): Promise<IncomeResponseDto> {
    return this.incomeService.createIncome(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Filter and paginate user income entries' })
  @ApiResponse({ status: 200, description: 'Paginated list of incomes returned' })
  async getIncomes(
    @CurrentUser('id') userId: string,
    @Query() queryDto: QueryIncomeDto,
  ) {
    return this.incomeService.getIncomes(userId, queryDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get income by UUID' })
  @ApiParam({ name: 'id', description: 'Income UUID' })
  @ApiResponse({ status: 200, description: 'Income returned', type: IncomeResponseDto })
  @ApiResponse({ status: 404, description: 'Income not found' })
  async getIncomeById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<IncomeResponseDto> {
    return this.incomeService.getIncomeById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update income entry by UUID' })
  @ApiParam({ name: 'id', description: 'Income UUID' })
  @ApiBody({ type: UpdateIncomeDto })
  @ApiResponse({ status: 200, description: 'Income updated successfully', type: IncomeResponseDto })
  @ApiResponse({ status: 404, description: 'Income not found' })
  async updateIncome(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateIncomeDto,
  ): Promise<IncomeResponseDto> {
    return this.incomeService.updateIncome(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete income entry by UUID' })
  @ApiParam({ name: 'id', description: 'Income UUID' })
  @ApiResponse({ status: 200, description: 'Income deleted successfully' })
  @ApiResponse({ status: 404, description: 'Income not found' })
  async deleteIncome(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.incomeService.deleteIncome(userId, id);
  }
}
