import { Controller, Post, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../auth/guards/roles.guard';
import { CurrentUser } from '../../../auth/decorators/current-user.decorator';
import { PlannerAIService } from '../services/planner-ai.service';
import { PrioritiseTasksRequestDto } from '../dto/prioritise-tasks-request.dto';
import { GenerateStudyPlanRequestDto } from '../dto/generate-study-plan-request.dto';
import { WorkloadAnalysisRequestDto } from '../dto/workload-analysis-request.dto';
import { ProductivityInsightsRequestDto } from '../dto/productivity-insights-request.dto';
import { DeadlineRiskRequestDto } from '../dto/deadline-risk-request.dto';
import { DailyPlanRequestDto } from '../dto/daily-plan-request.dto';
import { WeeklyPlanRequestDto } from '../dto/weekly-plan-request.dto';
import { AIPlanningResponseDto } from '../dto/ai-planning-response.dto';

@ApiTags('AI Planning Engine')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/ai')
export class PlannerAIController {
  constructor(private readonly aiService: PlannerAIService) {}

  @Post('prioritise')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI task prioritization engine evaluating deadlines, priority, and completion history' })
  @ApiBody({ type: PrioritiseTasksRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Tasks prioritized successfully',
    type: AIPlanningResponseDto,
  })
  async prioritiseTasks(
    @CurrentUser('id') userId: string,
    @Body() dto: PrioritiseTasksRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.prioritiseTasks(userId, dto);
  }

  @Post('study-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI study plan generation with subject allocations and break recommendations' })
  @ApiBody({ type: GenerateStudyPlanRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Study plan generated successfully',
    type: AIPlanningResponseDto,
  })
  async generateStudyPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: GenerateStudyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.generateStudyPlan(userId, dto);
  }

  @Post('workload-analysis')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI workload analysis detecting overloaded days and balancing schedule' })
  @ApiBody({ type: WorkloadAnalysisRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Workload analyzed successfully',
    type: AIPlanningResponseDto,
  })
  async analyseWorkload(
    @CurrentUser('id') userId: string,
    @Body() dto: WorkloadAnalysisRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.analyseWorkload(userId, dto);
  }

  @Post('productivity-insights')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI productivity insights evaluating focus scores, streaks, and habits' })
  @ApiBody({ type: ProductivityInsightsRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Productivity insights generated successfully',
    type: AIPlanningResponseDto,
  })
  async getProductivityInsights(
    @CurrentUser('id') userId: string,
    @Body() dto: ProductivityInsightsRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.getProductivityInsights(userId, dto);
  }

  @Post('deadline-risk')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI deadline risk detection identifying high-risk tasks and late assignment probabilities' })
  @ApiBody({ type: DeadlineRiskRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Deadline risks evaluated successfully',
    type: AIPlanningResponseDto,
  })
  async detectDeadlineRisk(
    @CurrentUser('id') userId: string,
    @Body() dto: DeadlineRiskRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.detectDeadlineRisk(userId, dto);
  }

  @Post('daily-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI daily time-blocked plan generation' })
  @ApiBody({ type: DailyPlanRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Daily plan generated successfully',
    type: AIPlanningResponseDto,
  })
  async generateDailyPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: DailyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.generateDailyPlan(userId, dto);
  }

  @Post('weekly-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI weekly academic schedule optimization' })
  @ApiBody({ type: WeeklyPlanRequestDto })
  @ApiResponse({
    status: 200,
    description: 'Weekly plan generated successfully',
    type: AIPlanningResponseDto,
  })
  async generateWeeklyPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: WeeklyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    return this.aiService.generateWeeklyPlan(userId, dto);
  }

  @Post('auto-extract')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'AI automatic task extraction from uploaded document or raw text note' })
  async autoExtractTask(
    @Body('content') content: string,
  ) {
    return this.aiService.autoExtractTask(content || '');
  }
}
