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
import { CareerGoalService } from '../services/career-goal.service';
import { CreateCareerGoalDto } from '../dto/create-career-goal.dto';
import { UpdateCareerGoalDto } from '../dto/update-career-goal.dto';
import { CareerGoalResponseDto } from '../dto/career-goal-response.dto';

@ApiTags('Career Goals')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/career-goals')
export class CareerGoalController {
  constructor(private readonly careerGoalService: CareerGoalService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new career goal' })
  @ApiBody({ type: CreateCareerGoalDto })
  @ApiResponse({
    status: 201,
    description: 'Career goal created successfully',
    type: CareerGoalResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async createCareerGoal(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateCareerGoalDto,
  ): Promise<CareerGoalResponseDto> {
    return this.careerGoalService.createCareerGoal(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all career goals for logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Career goals list returned',
    type: [CareerGoalResponseDto],
  })
  async getCareerGoals(
    @CurrentUser('id') userId: string,
  ): Promise<CareerGoalResponseDto[]> {
    return this.careerGoalService.getCareerGoals(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get specific career goal by ID' })
  @ApiParam({ name: 'id', description: 'Career goal UUID' })
  @ApiResponse({
    status: 200,
    description: 'Career goal details returned',
    type: CareerGoalResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Career goal not found' })
  async getCareerGoalById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<CareerGoalResponseDto> {
    return this.careerGoalService.getCareerGoalById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update career goal by ID' })
  @ApiParam({ name: 'id', description: 'Career goal UUID' })
  @ApiBody({ type: UpdateCareerGoalDto })
  @ApiResponse({
    status: 200,
    description: 'Career goal updated successfully',
    type: CareerGoalResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Career goal not found' })
  async updateCareerGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCareerGoalDto,
  ): Promise<CareerGoalResponseDto> {
    return this.careerGoalService.updateCareerGoal(userId, id, dto);
  }

  @Patch(':id/set-primary')
  @ApiOperation({ summary: 'Set specified career goal as primary goal for profile' })
  @ApiParam({ name: 'id', description: 'Career goal UUID' })
  @ApiResponse({
    status: 200,
    description: 'Career goal set as primary',
    type: CareerGoalResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Career goal not found' })
  async setPrimaryCareerGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<CareerGoalResponseDto> {
    return this.careerGoalService.setPrimaryCareerGoal(userId, id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete career goal by ID' })
  @ApiParam({ name: 'id', description: 'Career goal UUID' })
  @ApiResponse({ status: 200, description: 'Career goal deleted successfully' })
  @ApiResponse({ status: 404, description: 'Career goal not found' })
  async deleteCareerGoal(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.careerGoalService.deleteCareerGoal(userId, id);
  }
}
