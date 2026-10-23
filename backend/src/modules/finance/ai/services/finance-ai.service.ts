import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AIFinanceProviderFactory } from '../providers/ai-finance-provider.factory';
import { FinancePromptBuilder } from '../builders/finance-prompt.builder';
import { FinanceDataAggregator } from '../../analytics/aggregators/finance-data.aggregator';
import { AIFinancialAnalysisRepository } from '../repositories/ai-financial-analysis.repository';
import { SpendingPredictionRepository } from '../repositories/spending-prediction.repository';
import { SavingsRecommendationRepository } from '../repositories/savings-recommendation.repository';
import { AIFinanceUsageLogRepository } from '../repositories/ai-finance-usage-log.repository';
import { FinanceAICacheService } from './finance-ai-cache.service';
import { FinanceAIQueueProcessor } from '../queue/finance-ai.queue';
import { FinanceDateUtils } from '../../utils/finance-date.utils';

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
import { AIFinanceMapper } from '../mappers/ai-finance.mapper';
import { FinancialSummaryGeneratedEvent } from '../events/financial-summary-generated.event';
import { PredictionCompletedEvent } from '../events/prediction-completed.event';
import { SavingsRecommendationGeneratedEvent } from '../events/savings-recommendation-generated.event';

@Injectable()
export class FinanceAIService {
  private readonly logger = new Logger(FinanceAIService.name);

  constructor(
    private readonly providerFactory: AIFinanceProviderFactory,
    private readonly aggregator: FinanceDataAggregator,
    private readonly analysisRepository: AIFinancialAnalysisRepository,
    private readonly predictionRepository: SpendingPredictionRepository,
    private readonly savingsRepository: SavingsRecommendationRepository,
    private readonly usageLogRepository: AIFinanceUsageLogRepository,
    private readonly cacheService: FinanceAICacheService,
    private readonly queueProcessor: FinanceAIQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async generateFinancialSummary(
    userId: string,
    dto: AIAnalysisRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    if (dto.forceRefresh) {
      await this.cacheService.invalidateUserCache(userId);
    }

    const cacheKey = `ai_summary_${userId}_${dto.provider || 'default'}`;
    if (!dto.forceRefresh) {
      const cached = await this.cacheService.get<AIAnalysisResponseDto>(cacheKey);
      if (cached) return cached;
    }

    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider(dto.provider);

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('FINANCIAL_EXECUTIVE_SUMMARY')
      .setExtraInstructions(dto.notes)
      .build();

    const result = await provider.generateFinancialAnalysis(prompt, context);

    const analysis = this.analysisRepository.create(
      {
        userId,
        summary: result.summary,
        strengths: result.strengths,
        weaknesses: result.weaknesses,
        recommendations: result.recommendations,
        warnings: result.warnings,
        confidenceScore: result.confidenceScore,
        providerName: provider.providerName,
      },
      userId,
    );

    const saved = await this.analysisRepository.save(analysis, userId);
    const response = AIFinanceMapper.toAnalysisDto(saved);
    response.highestCategories = (context.categoryBreakdown || []).map((c) => ({
      categoryName: c.categoryName,
      amount: Number(c.totalAmount ?? 0),
      percentage: c.percentage,
      trendDirection: 'STABLE',
    }));
    response.dailyAverageSpent = context.elapsedDays && context.elapsedDays > 0
      ? parseFloat((context.totalExpenses / context.elapsedDays).toFixed(2))
      : 0;

    await this.logUsage(userId, provider.providerName, 'SUMMARY', Date.now() - startTime);
    await this.cacheService.set(cacheKey, response, 600);

    this.eventEmitter.emit(
      'finance.ai.summary_generated',
      new FinancialSummaryGeneratedEvent(saved.id, userId, provider.providerName),
    );

    return response;
  }

  async analyzeSpendingHabits(
    userId: string,
    dto: AIAnalysisRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    if (dto.forceRefresh) {
      await this.cacheService.invalidateUserCache(userId);
    }

    const cacheKey = `ai_spending_${userId}_${dto.provider || 'default'}`;
    if (!dto.forceRefresh) {
      const cached = await this.cacheService.get<AIAnalysisResponseDto>(cacheKey);
      if (cached) return cached;
    }

    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider(dto.provider);

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('FINANCIAL_SPENDING_ANALYSIS')
      .setExtraInstructions(dto.notes)
      .build();

    const result = await provider.generateFinancialAnalysis(prompt, context);

    const analysis = this.analysisRepository.create(
      {
        userId,
        summary: result.summary,
        strengths: result.strengths,
        weaknesses: result.weaknesses,
        recommendations: result.recommendations,
        warnings: result.warnings,
        confidenceScore: result.confidenceScore,
        providerName: provider.providerName,
      },
      userId,
    );

    const saved = await this.analysisRepository.save(analysis, userId);
    const response = AIFinanceMapper.toAnalysisDto(saved);
    response.highestCategories = (context.categoryBreakdown || []).map((c) => ({
      categoryName: c.categoryName,
      amount: Number(c.totalAmount ?? 0),
      percentage: c.percentage,
      trendDirection: 'STABLE',
    }));
    response.dailyAverageSpent = context.elapsedDays && context.elapsedDays > 0
      ? parseFloat((context.totalExpenses / context.elapsedDays).toFixed(2))
      : 0;

    await this.logUsage(userId, provider.providerName, 'SPENDING_ANALYSIS', Date.now() - startTime);
    await this.cacheService.set(cacheKey, response, 600);

    return response;
  }

  async predictMonthEndBalance(
    userId: string,
    dto: MonthEndPredictionRequestDto,
  ): Promise<MonthEndPredictionResponseDto> {
    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider(dto.provider);

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('MONTH_END_PREDICTION')
      .build();

    const result = await provider.predictMonthEndBalance(prompt, context);

    const now = new Date();
    const month = dto.month || now.getUTCMonth() + 1;
    const year = dto.year || now.getUTCFullYear();

    const prediction = this.predictionRepository.create(
      {
        userId,
        month,
        year,
        predictedMonthEndBalance: result.predictedMonthEndBalance,
        expectedTotalSpending: result.expectedTotalSpending,
        savingsAchievementProbability: result.savingsAchievementProbability,
        budgetExhaustionDate: result.budgetExhaustionDate ? new Date(result.budgetExhaustionDate) : null,
        reasoning: result.reasoning,
      },
      userId,
    );

    const saved = await this.predictionRepository.save(prediction, userId);
    const response = AIFinanceMapper.toPredictionDto(saved);

    await this.logUsage(userId, provider.providerName, 'PREDICTION', Date.now() - startTime);

    this.eventEmitter.emit(
      'finance.ai.prediction_completed',
      new PredictionCompletedEvent(saved.id, userId, result.predictedMonthEndBalance),
    );

    return response;
  }

  async calculateSafeDailyBudget(
    userId: string,
    dto: SafeDailyBudgetRequestDto,
  ): Promise<SafeDailyBudgetResponseDto> {
    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider();

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('SAFE_DAILY_BUDGET_CALCULATION')
      .setExtraInstructions(`Reserved upcoming expenses: $${dto.upcomingExpensesReserve || 0}`)
      .build();

    const result = await provider.calculateSafeDailyBudget(prompt, context);
    await this.logUsage(userId, provider.providerName, 'SAFE_DAILY_BUDGET', Date.now() - startTime);

    return {
      safeDailyLimit: result.safeDailyLimit,
      remainingBudget: result.remainingBudget,
      remainingDays: result.remainingDays,
      reservedSavings: result.reservedSavings,
      plannedUpcomingExpenses: dto.upcomingExpensesReserve || 0,
      mathematicalReasoning: result.mathematicalReasoning,
      behavioralGuidance: result.behavioralGuidance,
      confidenceScore: result.confidenceScore,
    };
  }

  async generateSavingsPlan(
    userId: string,
    dto: SavingsPlanRequestDto,
  ): Promise<SavingsPlanResponseDto> {
    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider();

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('SAVINGS_PLAN_GENERATION')
      .setExtraInstructions(dto.targetMonthlySavings ? `Target monthly savings: $${dto.targetMonthlySavings}` : undefined)
      .build();

    const result = await provider.generateSavingsPlan(prompt, context);

    const rec = this.savingsRepository.create(
      {
        userId,
        title: result.title,
        strategy: result.strategy,
        suggestedMonthlyContribution: result.suggestedMonthlyContribution,
        targetCategoriesToCut: result.targetCategoriesToCut,
        emergencyFundAdvice: result.emergencyFundAdvice,
      },
      userId,
    );

    const saved = await this.savingsRepository.save(rec, userId);
    const response = AIFinanceMapper.toSavingsPlanDto(saved);
    response.actionSteps = result.actionSteps || response.actionSteps;

    await this.logUsage(userId, provider.providerName, 'SAVINGS_PLAN', Date.now() - startTime);

    this.eventEmitter.emit(
      'finance.ai.savings_recommendation',
      new SavingsRecommendationGeneratedEvent(saved.id, userId, saved.title, saved.suggestedMonthlyContribution),
    );

    return response;
  }

  async forecastExpenses(
    userId: string,
    dto: ExpenseForecastRequestDto,
  ): Promise<ExpenseForecastResponseDto> {
    const startTime = Date.now();
    const context = await this.buildContext(userId);
    const provider = this.providerFactory.getProvider();

    const prompt = new FinancePromptBuilder()
      .setContext(context)
      .setTaskType('EXPENSE_FORECASTING')
      .setExtraInstructions(`Forecast horizon: ${dto.daysAhead || 30} days ahead`)
      .build();

    const result = await provider.forecastExpenses(prompt, context);
    await this.logUsage(userId, provider.providerName, 'FORECAST', Date.now() - startTime);

    return {
      forecastedItems: result.forecastedItems,
      totalForecastedAmount: result.totalForecastedAmount,
      summary: result.summary,
      confidenceScore: result.confidenceScore,
    };
  }

  async generateFinancialReview(
    userId: string,
    dto: FinancialReviewRequestDto,
  ): Promise<AIAnalysisResponseDto> {
    const focus = dto.reviewType ? ` | Focus: ${dto.reviewType}` : '';
    return this.generateFinancialSummary(userId, { notes: `Review Frequency: ${dto.frequency || 'MONTHLY'}${focus}` });
  }

  private async buildContext(userId: string) {
    const now = new Date();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();
    const startOfMonth = FinanceDateUtils.getStartOfMonth(year, month);
    const endOfMonth = FinanceDateUtils.getEndOfMonth(year, month);
    const totalDaysInMonth = new Date(year, month, 0).getDate();
    const elapsedDays = Math.min(now.getDate(), totalDaysInMonth);
    const daysRemainingInMonth = Math.max(1, totalDaysInMonth - elapsedDays);

    const aggregated = await this.aggregator.aggregatePeriodData(userId, startOfMonth, endOfMonth);
    const totalExpenses = aggregated.expenses.reduce((sum: number, e: any) => sum + Number(e.amount), 0);
    const totalIncome = aggregated.incomes.reduce((sum: number, i: any) => sum + Number(i.amount), 0);
    const netBalance = totalIncome - totalExpenses;
    const plannedBudget = aggregated.budget ? Number(aggregated.budget.plannedAmount) : 0;
    const remainingBudget = aggregated.budget ? Number(aggregated.budget.remainingAmount) : netBalance;
    const budgetUsagePercentage =
      plannedBudget > 0 && aggregated.budget
        ? parseFloat(((Number(aggregated.budget.spentAmount) / plannedBudget) * 100).toFixed(2))
        : 0;

    const normalDailyBudget = plannedBudget > 0 ? parseFloat((plannedBudget / totalDaysInMonth).toFixed(2)) : 0;
    const safeDailyLimit = remainingBudget > 0 && daysRemainingInMonth > 0 ? parseFloat((remainingBudget / daysRemainingInMonth).toFixed(2)) : 0;
    const projectedMonthEnd = elapsedDays > 0 && totalExpenses > 0 ? parseFloat(((totalExpenses / elapsedDays) * totalDaysInMonth).toFixed(2)) : totalExpenses;

    return {
      userId,
      budget: aggregated.budget,
      incomes: aggregated.incomes,
      expenses: aggregated.expenses,
      savingsGoals: aggregated.savingsGoals,
      categories: aggregated.categories || [],
      categoryBreakdown: aggregated.categoryBreakdown || [],
      totalIncome: parseFloat(totalIncome.toFixed(2)),
      totalExpenses: parseFloat(totalExpenses.toFixed(2)),
      netBalance: parseFloat(netBalance.toFixed(2)),
      remainingBudget: parseFloat(remainingBudget.toFixed(2)),
      budgetUsagePercentage,
      daysRemainingInMonth,
      totalDaysInMonth,
      elapsedDays,
      normalDailyBudget,
      safeDailyLimit,
      projectedMonthEnd,
      currencySymbol: '₹',
    };
  }

  private async logUsage(userId: string, providerName: string, operationType: string, latencyMs: number): Promise<void> {
    const log = this.usageLogRepository.create(
      {
        userId,
        providerName,
        operationType,
        promptTokenCount: 150,
        candidatesTokenCount: 250,
        latencyMs,
        isFallback: false,
      },
      userId,
    );
    await this.usageLogRepository.save(log, userId);
  }
}
