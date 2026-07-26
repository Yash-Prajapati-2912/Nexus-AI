import { Module, OnModuleInit } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileModule } from '../profile/profile.module';

// Foundation Entities
import { Budget } from './entities/budget.entity';
import { ExpenseCategory } from './entities/expense-category.entity';
import { Expense } from './entities/expense.entity';
import { Income } from './entities/income.entity';
import { SavingsGoal } from './entities/savings-goal.entity';
import { MonthlySummary } from './entities/monthly-summary.entity';

// Analytics Entities
import { FinancialAnalytics } from './entities/financial-analytics.entity';
import { FinancialMetric } from './entities/financial-metric.entity';
import { FinancialTrend } from './entities/financial-trend.entity';
import { BudgetAlert } from './entities/budget-alert.entity';
import { CategoryAnalytics } from './entities/category-analytics.entity';
import { CashFlowSummary } from './entities/cash-flow-summary.entity';
import { FinancialReport } from './entities/financial-report.entity';

// AI Intelligence Entities
import { AIFinancialAnalysis } from './ai/entities/ai-financial-analysis.entity';
import { SpendingPrediction } from './ai/entities/spending-prediction.entity';
import { BudgetRecommendation } from './ai/entities/budget-recommendation.entity';
import { SavingsRecommendation } from './ai/entities/savings-recommendation.entity';
import { FinancialInsight } from './ai/entities/financial-insight.entity';
import { ExpenseForecast } from './ai/entities/expense-forecast.entity';
import { FinancialRisk } from './ai/entities/financial-risk.entity';
import { AIFinanceUsageLog } from './ai/entities/ai-finance-usage-log.entity';

// Foundation Repositories
import { BudgetRepository } from './repositories/budget.repository';
import { ExpenseCategoryRepository } from './repositories/expense-category.repository';
import { ExpenseRepository } from './repositories/expense.repository';
import { IncomeRepository } from './repositories/income.repository';
import { SavingsGoalRepository } from './repositories/savings-goal.repository';
import { MonthlySummaryRepository } from './repositories/monthly-summary.repository';

// Analytics Repositories
import { FinancialAnalyticsRepository } from './repositories/financial-analytics.repository';
import { FinancialMetricRepository } from './repositories/financial-metric.repository';
import { FinancialTrendRepository } from './repositories/financial-trend.repository';
import { BudgetAlertRepository } from './repositories/budget-alert.repository';
import { CategoryAnalyticsRepository } from './repositories/category-analytics.repository';
import { CashFlowSummaryRepository } from './repositories/cash-flow-summary.repository';
import { FinancialReportRepository } from './repositories/financial-report.repository';

// AI Intelligence Repositories
import { AIFinancialAnalysisRepository } from './ai/repositories/ai-financial-analysis.repository';
import { SpendingPredictionRepository } from './ai/repositories/spending-prediction.repository';
import { BudgetRecommendationRepository } from './ai/repositories/budget-recommendation.repository';
import { SavingsRecommendationRepository } from './ai/repositories/savings-recommendation.repository';
import { FinancialInsightRepository } from './ai/repositories/financial-insight.repository';
import { ExpenseForecastRepository } from './ai/repositories/expense-forecast.repository';
import { FinancialRiskRepository } from './ai/repositories/financial-risk.repository';
import { AIFinanceUsageLogRepository } from './ai/repositories/ai-finance-usage-log.repository';

// AI Providers, Builders & Queue
import { GeminiFinanceProvider } from './ai/providers/gemini-finance.provider';
import { AIFinanceProviderFactory } from './ai/providers/ai-finance-provider.factory';
import { FinanceAIQueueProcessor } from './ai/queue/finance-ai.queue';
import { FinanceAICacheService } from './ai/services/finance-ai-cache.service';
import { FinanceAIService } from './ai/services/finance-ai.service';

// Aggregators & Export Engine
import { FinanceDataAggregator } from './analytics/aggregators/finance-data.aggregator';
import { ReportExportService } from './export/services/report-export.service';
import { ReportGeneratorService } from './reports/services/report-generator.service';

// Services
import { BudgetService } from './services/budget.service';
import { ExpenseCategoryService } from './services/expense-category.service';
import { ExpenseService } from './services/expense.service';
import { IncomeService } from './services/income.service';
import { SavingsGoalService } from './services/savings-goal.service';
import { MonthlySummaryService } from './services/monthly-summary.service';
import { FinancialAnalyticsService } from './services/financial-analytics.service';
import { CashFlowService } from './services/cash-flow.service';
import { TrendAnalyticsService } from './services/trend-analytics.service';
import { BudgetAlertService } from './services/budget-alert.service';
import { DashboardWidgetService } from './services/dashboard-widget.service';

// Controllers
import { BudgetController } from './controllers/budget.controller';
import { ExpenseCategoryController } from './controllers/expense-category.controller';
import { ExpenseController } from './controllers/expense.controller';
import { IncomeController } from './controllers/income.controller';
import { SavingsGoalController } from './controllers/savings-goal.controller';
import { MonthlySummaryController } from './controllers/monthly-summary.controller';
import { FinancialAnalyticsController } from './controllers/financial-analytics.controller';
import { CashFlowController } from './controllers/cash-flow.controller';
import { BudgetAlertController } from './controllers/budget-alert.controller';
import { DashboardWidgetController } from './controllers/dashboard-widget.controller';
import { FinancialReportController } from './controllers/financial-report.controller';
import { FinanceAIController } from './ai/controllers/finance-ai.controller';

// Listeners
import { FinanceSummaryListener } from './listeners/finance-summary.listener';
import { FinanceAuditListener } from './listeners/finance-audit.listener';
import { FinanceAnalyticsListener } from './listeners/finance-analytics.listener';
import { FinanceAIHooksListener } from './listeners/finance-ai-hooks.listener';
import { AnalyticsCacheListener } from './listeners/analytics-cache.listener';
import { DashboardUpdateListener } from './listeners/dashboard-update.listener';
import { BudgetAlertListener } from './listeners/budget-alert.listener';
import { AIAnalyticsListener } from './ai/listeners/ai-analytics.listener';
import { AIUsageLoggingListener } from './ai/listeners/ai-usage-logging.listener';
import { AIDashboardUpdateListener } from './ai/listeners/ai-dashboard-update.listener';
import { AINotificationListener } from './ai/listeners/ai-notification.listener';

@Module({
  imports: [
    ProfileModule,
    TypeOrmModule.forFeature([
      Budget,
      ExpenseCategory,
      Expense,
      Income,
      SavingsGoal,
      MonthlySummary,
      FinancialAnalytics,
      FinancialMetric,
      FinancialTrend,
      BudgetAlert,
      CategoryAnalytics,
      CashFlowSummary,
      FinancialReport,
      AIFinancialAnalysis,
      SpendingPrediction,
      BudgetRecommendation,
      SavingsRecommendation,
      FinancialInsight,
      ExpenseForecast,
      FinancialRisk,
      AIFinanceUsageLog,
    ]),
  ],
  controllers: [
    BudgetController,
    ExpenseCategoryController,
    ExpenseController,
    IncomeController,
    SavingsGoalController,
    MonthlySummaryController,
    FinancialAnalyticsController,
    CashFlowController,
    BudgetAlertController,
    DashboardWidgetController,
    FinancialReportController,
    FinanceAIController,
  ],
  providers: [
    // Repositories
    BudgetRepository,
    ExpenseCategoryRepository,
    ExpenseRepository,
    IncomeRepository,
    SavingsGoalRepository,
    MonthlySummaryRepository,
    FinancialAnalyticsRepository,
    FinancialMetricRepository,
    FinancialTrendRepository,
    BudgetAlertRepository,
    CategoryAnalyticsRepository,
    CashFlowSummaryRepository,
    FinancialReportRepository,
    AIFinancialAnalysisRepository,
    SpendingPredictionRepository,
    BudgetRecommendationRepository,
    SavingsRecommendationRepository,
    FinancialInsightRepository,
    ExpenseForecastRepository,
    FinancialRiskRepository,
    AIFinanceUsageLogRepository,

    // AI Providers & Infrastructure
    GeminiFinanceProvider,
    AIFinanceProviderFactory,
    FinanceAIQueueProcessor,
    FinanceAICacheService,
    FinanceAIService,

    // Aggregators & Export
    FinanceDataAggregator,
    ReportExportService,
    ReportGeneratorService,

    // Domain Services
    BudgetService,
    ExpenseCategoryService,
    ExpenseService,
    IncomeService,
    SavingsGoalService,
    MonthlySummaryService,
    FinancialAnalyticsService,
    CashFlowService,
    TrendAnalyticsService,
    BudgetAlertService,
    DashboardWidgetService,

    // Event Listeners
    FinanceSummaryListener,
    FinanceAuditListener,
    FinanceAnalyticsListener,
    FinanceAIHooksListener,
    AnalyticsCacheListener,
    DashboardUpdateListener,
    BudgetAlertListener,
    AIAnalyticsListener,
    AIUsageLoggingListener,
    AIDashboardUpdateListener,
    AINotificationListener,
  ],
  exports: [
    BudgetRepository,
    ExpenseRepository,
    BudgetService,
    ExpenseCategoryService,
    ExpenseService,
    IncomeService,
    SavingsGoalService,
    MonthlySummaryService,
    FinancialAnalyticsService,
    CashFlowService,
    TrendAnalyticsService,
    BudgetAlertService,
    DashboardWidgetService,
    ReportGeneratorService,
    ReportExportService,
    FinanceAIService,
    GeminiFinanceProvider,
    AIFinanceProviderFactory,
  ],
})
export class FinanceModule implements OnModuleInit {
  constructor(private readonly categoryService: ExpenseCategoryService) {}

  async onModuleInit(): Promise<void> {
    await this.categoryService.seedDefaultCategories();
  }
}
