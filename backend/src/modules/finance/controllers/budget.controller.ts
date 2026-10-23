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
  ParseIntPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiQuery,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { BudgetService } from '../services/budget.service';
import { CreateBudgetDto } from '../dto/create-budget.dto';
import { UpdateBudgetDto } from '../dto/update-budget.dto';
import { DuplicateBudgetDto } from '../dto/duplicate-budget.dto';
import { BudgetResponseDto } from '../dto/budget-response.dto';

@ApiTags('Smart Finance - Budgets')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/budgets')
export class BudgetController {
  constructor(private readonly budgetService: BudgetService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create monthly budget', description: 'Enforces max one active budget per user per calendar month and year.' })
  @ApiBody({ type: CreateBudgetDto })
  @ApiResponse({ status: 201, description: 'Budget created successfully', type: BudgetResponseDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Budget for this period already exists' })
  async createBudget(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateBudgetDto,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.createBudget(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all user budgets' })
  @ApiResponse({ status: 200, description: 'Budgets array returned', type: [BudgetResponseDto] })
  async getUserBudgets(
    @CurrentUser('id') userId: string,
  ): Promise<BudgetResponseDto[]> {
    return this.budgetService.getUserBudgets(userId);
  }

  @Get('active')
  @ApiOperation({ summary: 'Get active budget for current or specified period' })
  @ApiQuery({ name: 'month', required: false, description: 'Month integer (1-12)' })
  @ApiQuery({ name: 'year', required: false, description: 'Year integer (2000-2100)' })
  @ApiResponse({ status: 200, description: 'Active budget returned', type: BudgetResponseDto })
  @ApiResponse({ status: 404, description: 'No active budget found' })
  async getActiveBudget(
    @CurrentUser('id') userId: string,
    @Query('month', new ParseIntPipe({ optional: true })) month?: number,
    @Query('year', new ParseIntPipe({ optional: true })) year?: number,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.getActiveBudget(userId, month, year);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get budget by UUID' })
  @ApiParam({ name: 'id', description: 'Budget UUID' })
  @ApiResponse({ status: 200, description: 'Budget returned', type: BudgetResponseDto })
  @ApiResponse({ status: 404, description: 'Budget not found' })
  async getBudgetById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.getBudgetById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update budget by UUID' })
  @ApiParam({ name: 'id', description: 'Budget UUID' })
  @ApiBody({ type: UpdateBudgetDto })
  @ApiResponse({ status: 200, description: 'Budget updated successfully', type: BudgetResponseDto })
  @ApiResponse({ status: 404, description: 'Budget not found' })
  async updateBudget(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateBudgetDto,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.updateBudget(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete budget by UUID' })
  @ApiParam({ name: 'id', description: 'Budget UUID' })
  @ApiResponse({ status: 200, description: 'Budget deleted successfully' })
  @ApiResponse({ status: 404, description: 'Budget not found' })
  async deleteBudget(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.budgetService.deleteBudget(userId, id);
  }

  @Post(':id/close')
  @ApiOperation({ summary: 'Close active budget' })
  @ApiParam({ name: 'id', description: 'Budget UUID' })
  @ApiResponse({ status: 200, description: 'Budget status set to CLOSED', type: BudgetResponseDto })
  @ApiResponse({ status: 404, description: 'Budget not found' })
  async closeBudget(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.closeBudget(userId, id);
  }

  @Post(':id/duplicate')
  @ApiOperation({ summary: 'Duplicate budget into target period' })
  @ApiParam({ name: 'id', description: 'Source Budget UUID' })
  @ApiBody({ type: DuplicateBudgetDto })
  @ApiResponse({ status: 201, description: 'Budget duplicated successfully', type: BudgetResponseDto })
  @ApiResponse({ status: 409, description: 'Target period budget already exists' })
  async duplicateBudget(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: DuplicateBudgetDto,
  ): Promise<BudgetResponseDto> {
    return this.budgetService.duplicateBudget(userId, id, dto);
  }
}
