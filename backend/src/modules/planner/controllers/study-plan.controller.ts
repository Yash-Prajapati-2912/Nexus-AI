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
import { StudyPlanService } from '../services/study-plan.service';
import { CreateStudyPlanDto } from '../dto/create-study-plan.dto';
import { UpdateStudyPlanDto } from '../dto/update-study-plan.dto';
import { StudyPlanResponseDto } from '../dto/study-plan-response.dto';

@ApiTags('Planner Study Plans')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/study-plans')
export class StudyPlanController {
  constructor(private readonly studyPlanService: StudyPlanService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new course study plan' })
  @ApiBody({ type: CreateStudyPlanDto })
  @ApiResponse({
    status: 201,
    description: 'Study plan created successfully',
    type: StudyPlanResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createStudyPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateStudyPlanDto,
  ): Promise<StudyPlanResponseDto> {
    return this.studyPlanService.createStudyPlan(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get list of study plans for logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Study plans list returned',
    type: [StudyPlanResponseDto],
  })
  async getStudyPlans(
    @CurrentUser('id') userId: string,
  ): Promise<StudyPlanResponseDto[]> {
    return this.studyPlanService.getStudyPlans(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get study plan details by ID' })
  @ApiParam({ name: 'id', description: 'StudyPlan UUID' })
  @ApiResponse({
    status: 200,
    description: 'Study plan details returned',
    type: StudyPlanResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Study plan not found' })
  async getStudyPlanById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<StudyPlanResponseDto> {
    return this.studyPlanService.getStudyPlanById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update study plan by ID' })
  @ApiParam({ name: 'id', description: 'StudyPlan UUID' })
  @ApiBody({ type: UpdateStudyPlanDto })
  @ApiResponse({
    status: 200,
    description: 'Study plan updated successfully',
    type: StudyPlanResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Study plan not found' })
  async updateStudyPlan(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateStudyPlanDto,
  ): Promise<StudyPlanResponseDto> {
    return this.studyPlanService.updateStudyPlan(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete study plan by ID' })
  @ApiParam({ name: 'id', description: 'StudyPlan UUID' })
  @ApiResponse({ status: 200, description: 'Study plan deleted successfully' })
  @ApiResponse({ status: 404, description: 'Study plan not found' })
  async deleteStudyPlan(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.studyPlanService.deleteStudyPlan(userId, id);
  }
}
