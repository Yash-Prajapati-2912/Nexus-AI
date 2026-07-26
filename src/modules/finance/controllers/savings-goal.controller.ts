import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
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
import { SavingsGoalService } from '../services/savings-goal.service';
import { CreateSavingsGoalDto } from '../dto/create-savings-goal.dto';
import { UpdateSavingsGoalDto } from '../dto/update-savings-goal.dto';
import { SavingsGoalProgressDto } from '../dto/savings-goal-progress.dto';
import { SavingsGoalResponseDto } from '../dto/savings-goal-response.dto';

@ApiTags('Smart Finance - Savings Goals')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/savings-goals')
export class SavingsGoalController {
  constructor(private readonly savingsGoalService: SavingsGoalService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create savings target goal' })
  @ApiBody({ type: CreateSavingsGoalDto })
  @ApiResponse({ status: 201, description: 'Savings Goal created successfully', type: SavingsGoalResponseDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createGoal(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSavingsGoalDto,
  ): Promise<SavingsGoalResponseDto> {
    return this.savingsGoalService.createGoal(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get user savings goals' })
  @ApiResponse({ status: 200, description: 'Array of savings goals returned', type: [SavingsGoalResponseDto] })
  async getUserGoals(
    @CurrentUser('id') userId: string,
  ): Promise<SavingsGoalResponseDto[]> {
    return this.savingsGoalService.getUserGoals(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get savings goal by UUID' })
  @ApiParam({ name: 'id', description: 'Savings Goal UUID' })
  @ApiResponse({ status: 200, description: 'Savings Goal returned', type: SavingsGoalResponseDto })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async getGoalById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<SavingsGoalResponseDto> {
    return this.savingsGoalService.getGoalById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update savings goal details' })
  @ApiParam({ name: 'id', description: 'Savings Goal UUID' })
  @ApiBody({ type: UpdateSavingsGoalDto })
  @ApiResponse({ status: 200, description: 'Savings Goal updated successfully', type: SavingsGoalResponseDto })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async updateGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateSavingsGoalDto,
  ): Promise<SavingsGoalResponseDto> {
    return this.savingsGoalService.updateGoal(userId, id, dto);
  }

  @Patch(':id/progress')
  @ApiOperation({ summary: 'Track contribution progress toward savings goal' })
  @ApiParam({ name: 'id', description: 'Savings Goal UUID' })
  @ApiBody({ type: SavingsGoalProgressDto })
  @ApiResponse({ status: 200, description: 'Savings Goal progress updated', type: SavingsGoalResponseDto })
  @ApiResponse({ status: 400, description: 'Goal already completed' })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async trackProgress(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: SavingsGoalProgressDto,
  ): Promise<SavingsGoalResponseDto> {
    return this.savingsGoalService.trackProgress(userId, id, dto);
  }

  @Post(':id/complete')
  @ApiOperation({ summary: 'Mark savings goal as completed' })
  @ApiParam({ name: 'id', description: 'Savings Goal UUID' })
  @ApiResponse({ status: 200, description: 'Savings Goal completed', type: SavingsGoalResponseDto })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async completeGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<SavingsGoalResponseDto> {
    return this.savingsGoalService.completeGoal(userId, id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete savings goal by UUID' })
  @ApiParam({ name: 'id', description: 'Savings Goal UUID' })
  @ApiResponse({ status: 200, description: 'Savings Goal deleted successfully' })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async deleteGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.savingsGoalService.deleteGoal(userId, id);
  }
}
