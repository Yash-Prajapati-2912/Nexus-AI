import { IAIFinancePromptContext } from './ai-finance-prompt-context.interface';
import {
  IAIFinancialAnalysisResult,
  IAIMonthEndPredictionResult,
  IAISafeDailyBudgetResult,
  IAISavingsPlanResult,
  IAIExpenseForecastResult,
} from './ai-finance-response.interface';

/**
 * Strategy interface for AI Financial Provider instances.
 */
export interface IAIFinanceProvider {
  readonly providerName: string;

  generateFinancialAnalysis(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIFinancialAnalysisResult>;

  predictMonthEndBalance(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIMonthEndPredictionResult>;

  calculateSafeDailyBudget(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAISafeDailyBudgetResult>;

  generateSavingsPlan(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAISavingsPlanResult>;

  forecastExpenses(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIExpenseForecastResult>;
}
