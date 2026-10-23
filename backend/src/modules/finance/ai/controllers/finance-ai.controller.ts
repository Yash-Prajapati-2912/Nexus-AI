import { Controller, Post, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
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
import { FinanceAIService } from '../services/finance-ai.service';
import { AIAnalysisRequestDto } from '../dto/ai-analysis-request.dto';
import { AIAnalysisResponseDto } from '../dto/ai-analysis-response.dto';
import { MonthEndPredictionRequestDto } from '../dto/month-end-prediction-request.dto';
import { MonthEndPredictionResponseDto } from '../dto/month-end-prediction-response.dto';
import { SafeDailyBudgetRequestDto } from '../dto/safe-daily-budget-request.dto';
import { SafeDailyBudgetResponseDto } from '../dto/safe-daily-budget-response.dto';
import { ExpenseForecastRequestDto } from '../dto/expense-forecast-request.dto';
import { ExpenseForecastResponseDto } from '../dto/expense-forecast-response.dto';
import { SavingsPlanRequestDto } from '../dto/savings-plan-request.dto';
import { SavingsPlanResponseDto } from '../dto/savings-plan-response.dto';
import { FinancialReviewRequestDto } from '../dto/financial-review-request.dto';

@ApiTags('Smart Finance - AI Financial Advisor')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/ai')
export class FinanceAIController {
  constructor(private readonly aiService: FinanceAIService) {}

  @Post('summary')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate AI Financial Executive Summary' })
  @ApiBody({ type: AIAnalysisRequestDto })
  @ApiResponse({ status: 200, description: 'Executive summary generated', type: AIAnalysisResponseDto })
  async generateFinancialSummary(
    @CurrentUser('id') userId: string,
    @Body() dto: AIAnalysisRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    return this.aiService.generateFinancialSummary(userId, dto);
  }

  @Post('spending-analysis')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Analyze student spending habits and category patterns' })
  @ApiBody({ type: AIAnalysisRequestDto })
  @ApiResponse({ status: 200, description: 'Spending analysis generated', type: AIAnalysisResponseDto })
  async analyzeSpendingHabits(
    @CurrentUser('id') userId: string,
    @Body() dto: AIAnalysisRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    return this.aiService.analyzeSpendingHabits(userId, dto);
  }

  @Post('month-end-prediction')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Predict month-end remaining balance and savings probability' })
  @ApiBody({ type: MonthEndPredictionRequestDto })
  @ApiResponse({ status: 200, description: 'Month-end prediction generated', type: MonthEndPredictionResponseDto })
  async predictMonthEndBalance(
    @CurrentUser('id') userId: string,
    @Body() dto: MonthEndPredictionRequestDto,
  ): Promise<MonthEndPredictionResponseDto> {
    return this.aiService.predictMonthEndBalance(userId, dto);
  }

  @Post('safe-daily-budget')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Calculate safe daily spending limit with explicit mathematical reasoning' })
  @ApiBody({ type: SafeDailyBudgetRequestDto })
  @ApiResponse({ status: 200, description: 'Safe daily spending limit calculated', type: SafeDailyBudgetResponseDto })
  async calculateSafeDailyBudget(
    @CurrentUser('id') userId: string,
    @Body() dto: SafeDailyBudgetRequestDto,
  ): Promise<SafeDailyBudgetResponseDto> {
    return this.aiService.calculateSafeDailyBudget(userId, dto);
  }

  @Post('savings-plan')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate goal-based AI savings strategy and expense reduction plan' })
  @ApiBody({ type: SavingsPlanRequestDto })
  @ApiResponse({ status: 200, description: 'Savings strategy generated', type: SavingsPlanResponseDto })
  async generateSavingsPlan(
    @CurrentUser('id') userId: string,
    @Body() dto: SavingsPlanRequestDto,
  ): Promise<SavingsPlanResponseDto> {
    return this.aiService.generateSavingsPlan(userId, dto);
  }

  @Post('forecast')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Forecast upcoming future expenses and recurring commitments' })
  @ApiBody({ type: ExpenseForecastRequestDto })
  @ApiResponse({ status: 200, description: 'Expense forecast generated', type: ExpenseForecastResponseDto })
  async forecastExpenses(
    @CurrentUser('id') userId: string,
    @Body() dto: ExpenseForecastRequestDto,
  ): Promise<ExpenseForecastResponseDto> {
    return this.aiService.forecastExpenses(userId, dto);
  }

  @Post('financial-review')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Generate comprehensive weekly or monthly AI financial review' })
  @ApiBody({ type: FinancialReviewRequestDto })
  @ApiResponse({ status: 200, description: 'Financial review generated', type: AIAnalysisResponseDto })
  async generateFinancialReview(
    @CurrentUser('id') userId: string,
    @Body() dto: FinancialReviewRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    return this.aiService.generateFinancialReview(userId, dto);
  }
}
