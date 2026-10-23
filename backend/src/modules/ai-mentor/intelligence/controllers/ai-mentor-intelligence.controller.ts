import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../auth/guards/roles.guard';
import { CurrentUser } from '../../../auth/decorators/current-user.decorator';
import { AIMentorIntelligenceService } from '../services/ai-mentor-intelligence.service';
import { CareerRoadmapRequestDto } from '../dto/career-roadmap-request.dto';
import { CareerRoadmapResponseDto } from '../dto/career-roadmap-response.dto';
import { StudyAnalysisRequestDto } from '../dto/study-analysis-request.dto';
import { StudyAnalysisResponseDto } from '../dto/study-analysis-response.dto';
import { GoalPlanRequestDto } from '../dto/goal-plan-request.dto';
import { GoalPlanResponseDto } from '../dto/goal-plan-response.dto';
import { DecisionAnalysisRequestDto } from '../dto/decision-analysis-request.dto';
import { DecisionAnalysisResponseDto } from '../dto/decision-analysis-response.dto';
import { HabitCoachingRequestDto } from '../dto/habit-coaching-request.dto';
import { HabitCoachingResponseDto } from '../dto/habit-coaching-response.dto';
import { ActionPlanRequestDto } from '../dto/action-plan-request.dto';
import { ActionPlanResponseDto } from '../dto/action-plan-response.dto';
import { RecommendationFeedbackRequestDto } from '../dto/recommendation-feedback-request.dto';
import { IStudentWellnessScores } from '../scoring/student-wellness.scoring';

@ApiTags('AI Mentor - Intelligence Engine')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('mentor')
export class AIMentorIntelligenceController {
  constructor(private readonly intelligenceService: AIMentorIntelligenceService) {}

  @Post('career-roadmap')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate Career Gap Analysis, Placement Readiness Score, and Milestone Roadmap' })
  @ApiBody({ type: CareerRoadmapRequestDto })
  @ApiResponse({ status: 200, description: 'Career roadmap generated', type: CareerRoadmapResponseDto })
  async generateCareerRoadmap(
    @CurrentUser('id') userId: string,
    @Body() dto: CareerRoadmapRequestDto,
  ): Promise<CareerRoadmapResponseDto> {
    return this.intelligenceService.generateCareerRoadmap(userId, dto);
  }

  @Post('study-analysis')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate Subject Priority Analysis, Weak Subject Detection, and Exam Prep Strategy' })
  @ApiBody({ type: StudyAnalysisRequestDto })
  @ApiResponse({ status: 200, description: 'Study analysis generated', type: StudyAnalysisResponseDto })
  async analyzeStudySchedule(
    @CurrentUser('id') userId: string,
    @Body() dto: StudyAnalysisRequestDto,
  ): Promise<StudyAnalysisResponseDto> {
    return this.intelligenceService.analyzeStudySchedule(userId, dto);
  }

  @Post('goal-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Decompose Goals into SMART Milestones with Risk Scoring & Success Probability' })
  @ApiBody({ type: GoalPlanRequestDto })
  @ApiResponse({ status: 200, description: 'Goal plan created', type: GoalPlanResponseDto })
  async createGoalPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: GoalPlanRequestDto,
  ): Promise<GoalPlanResponseDto> {
    return this.intelligenceService.createGoalPlan(userId, dto);
  }

  @Post('decision-analysis')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Perform Decision Trade-off Analysis, Pros/Cons, and Opportunity Cost Evaluation' })
  @ApiBody({ type: DecisionAnalysisRequestDto })
  @ApiResponse({ status: 200, description: 'Decision analysis completed', type: DecisionAnalysisResponseDto })
  async analyzeDecision(
    @CurrentUser('id') userId: string,
    @Body() dto: DecisionAnalysisRequestDto,
  ): Promise<DecisionAnalysisResponseDto> {
    return this.intelligenceService.analyzeDecision(userId, dto);
  }

  @Post('habit-coaching')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate Daily/Weekly Habits and Burnout Prevention Recommendations' })
  @ApiBody({ type: HabitCoachingRequestDto })
  @ApiResponse({ status: 200, description: 'Habit coaching generated', type: HabitCoachingResponseDto })
  async getHabitCoaching(
    @CurrentUser('id') userId: string,
    @Body() dto: HabitCoachingRequestDto,
  ): Promise<HabitCoachingResponseDto> {
    return this.intelligenceService.getHabitCoaching(userId, dto);
  }

  @Post('action-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate Structured Action Plan with Time Estimates and Expected Outcomes' })
  @ApiBody({ type: ActionPlanRequestDto })
  @ApiResponse({ status: 200, description: 'Action plan generated', type: ActionPlanResponseDto })
  async generateActionPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: ActionPlanRequestDto,
  ): Promise<ActionPlanResponseDto> {
    return this.intelligenceService.generateActionPlan(userId, dto);
  }

  @Post('feedback')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Submit Feedback Rating & Learn Adaptive Recommendation Weightings' })
  @ApiBody({ type: RecommendationFeedbackRequestDto })
  @ApiResponse({ status: 200, description: 'Feedback recorded and weighting updated' })
  async submitFeedback(
    @CurrentUser('id') userId: string,
    @Body() dto: RecommendationFeedbackRequestDto,
  ): Promise<{ success: boolean; weightAdjustment: number }> {
    return this.intelligenceService.submitFeedback(userId, dto);
  }

  @Get('wellness-scores')
  @ApiOperation({ summary: 'Get 7-Dimension Student Wellness & Performance Scores' })
  @ApiResponse({ status: 200, description: 'Student wellness scores calculated' })
  async getStudentWellnessScores(
    @CurrentUser('id') userId: string,
  ): Promise<IStudentWellnessScores> {
    return this.intelligenceService.getStudentWellnessScores(userId);
  }
}
