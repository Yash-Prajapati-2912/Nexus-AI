import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { IAIFinanceProvider } from '../interfaces/ai-finance-provider.interface';
import { IAIFinancePromptContext } from '../interfaces/ai-finance-prompt-context.interface';
import {
  IAIFinancialAnalysisResult,
  IAIMonthEndPredictionResult,
  IAISafeDailyBudgetResult,
  IAISavingsPlanResult,
  IAIExpenseForecastResult,
} from '../interfaces/ai-finance-response.interface';

@Injectable()
export class GeminiFinanceProvider implements IAIFinanceProvider {
  readonly providerName = 'GEMINI';
  private readonly logger = new Logger(GeminiFinanceProvider.name);
  private genAI: GoogleGenerativeAI | null = null;
  private modelName: string;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('gemini.apiKey') || process.env.GEMINI_API_KEY;
    this.modelName = this.configService.get<string>('gemini.model') || 'gemini-1.5-flash';
    if (apiKey && apiKey !== 'dev_gemini_api_key_placeholder') {
      this.genAI = new GoogleGenerativeAI(apiKey);
    }
  }

  async generateFinancialAnalysis(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIFinancialAnalysisResult> {
    const systemInstruction = `
You are the AI Financial Intelligence Engine for Nexus AI (Student Life Operating System).
Analyze student income, expenses, budgets, savings goals, and spending distribution.
Output ONLY a valid JSON object matching this exact schema:
{
  "summary": "Executive summary of financial health",
  "strengths": ["point 1", "point 2"],
  "weaknesses": ["point 1", "point 2"],
  "recommendations": [
    {
      "title": "Recommendation title",
      "description": "Details",
      "priority": "HIGH",
      "category": "Food & Dining",
      "potentialSavings": 50
    }
  ],
  "warnings": ["Warning if overspending"],
  "confidenceScore": 0.92
}
No markdown block formatting wrappers. Output clean raw JSON only.
`;

    try {
      if (!this.genAI) return this.getFallbackAnalysis(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const res = await model.generateContent(`${systemInstruction}\n\n${prompt}`);
      const cleaned = res.response.text().replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleaned) as IAIFinancialAnalysisResult;
    } catch (err: any) {
      this.logger.error(`Gemini provider analysis error: ${err.message}`);
      return this.getFallbackAnalysis(context);
    }
  }

  async predictMonthEndBalance(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIMonthEndPredictionResult> {
    const systemInstruction = `
You are the AI Financial Prediction Engine for Nexus AI.
Output ONLY a valid JSON object matching:
{
  "predictedMonthEndBalance": 350.0,
  "expectedTotalSpending": 650.0,
  "savingsAchievementProbability": 85.5,
  "budgetExhaustionDate": null,
  "reasoning": "Mathematical breakdown",
  "confidenceScore": 0.89
}
No markdown. Clean JSON only.
`;

    try {
      if (!this.genAI) return this.getFallbackPrediction(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const res = await model.generateContent(`${systemInstruction}\n\n${prompt}`);
      const cleaned = res.response.text().replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleaned) as IAIMonthEndPredictionResult;
    } catch (err: any) {
      this.logger.error(`Gemini provider prediction error: ${err.message}`);
      return this.getFallbackPrediction(context);
    }
  }

  async calculateSafeDailyBudget(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAISafeDailyBudgetResult> {
    const systemInstruction = `
You are the AI Safe Daily Spending Calculator for Nexus AI.
Output ONLY a valid JSON object matching:
{
  "safeDailyLimit": 25.0,
  "remainingBudget": 350.0,
  "remainingDays": 14,
  "reservedSavings": 50.0,
  "plannedUpcomingExpenses": 0.0,
  "mathematicalReasoning": "Safe Limit = (350 - 50) / 14 = 21.43",
  "behavioralGuidance": ["Limit coffee purchases to $5/day"],
  "confidenceScore": 0.95
}
No markdown. Clean JSON only.
`;

    try {
      if (!this.genAI) return this.getFallbackSafeDailyBudget(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.1, responseMimeType: 'application/json' },
      });

      const res = await model.generateContent(`${systemInstruction}\n\n${prompt}`);
      const cleaned = res.response.text().replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleaned) as IAISafeDailyBudgetResult;
    } catch (err: any) {
      this.logger.error(`Gemini provider safe daily budget error: ${err.message}`);
      return this.getFallbackSafeDailyBudget(context);
    }
  }

  async generateSavingsPlan(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAISavingsPlanResult> {
    const systemInstruction = `
You are the AI Savings Coach for Nexus AI.
Output ONLY a valid JSON object matching:
{
  "title": "Semester Emergency & Laptop Savings Plan",
  "strategy": "Automate $40 weekly deposits and cap dining out",
  "suggestedMonthlyContribution": 160.0,
  "targetCategoriesToCut": ["Entertainment", "Food & Dining"],
  "emergencyFundAdvice": "Build a 1-month $500 safety buffer",
  "actionSteps": [
    { "step": 1, "title": "Set up weekly transfer", "description": "Transfer $40 on payday" }
  ],
  "confidenceScore": 0.91
}
No markdown. Clean JSON only.
`;

    try {
      if (!this.genAI) return this.getFallbackSavingsPlan(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const res = await model.generateContent(`${systemInstruction}\n\n${prompt}`);
      const cleaned = res.response.text().replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleaned) as IAISavingsPlanResult;
    } catch (err: any) {
      this.logger.error(`Gemini provider savings plan error: ${err.message}`);
      return this.getFallbackSavingsPlan(context);
    }
  }

  async forecastExpenses(
    prompt: string,
    context: IAIFinancePromptContext,
  ): Promise<IAIExpenseForecastResult> {
    const systemInstruction = `
You are the AI Expense Forecasting Engine for Nexus AI.
Output ONLY a valid JSON object matching:
{
  "forecastedItems": [
    { "title": "Monthly Wifi", "categoryName": "Housing & Rent", "forecastedAmount": 50, "forecastDate": "2026-09-01", "confidence": 0.95 }
  ],
  "totalForecastedAmount": 50.0,
  "summary": "Projected upcoming recurring expenses",
  "confidenceScore": 0.88
}
No markdown. Clean JSON only.
`;

    try {
      if (!this.genAI) return this.getFallbackExpenseForecast(context);

      const model = this.genAI.getGenerativeModel({
        model: this.modelName,
        generationConfig: { temperature: 0.2, responseMimeType: 'application/json' },
      });

      const res = await model.generateContent(`${systemInstruction}\n\n${prompt}`);
      const cleaned = res.response.text().replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleaned) as IAIExpenseForecastResult;
    } catch (err: any) {
      this.logger.error(`Gemini provider forecasting error: ${err.message}`);
      return this.getFallbackExpenseForecast(context);
    }
  }

  // Deterministic Fallback Generators for Dev / Offline Mode
  private getFallbackAnalysis(context: IAIFinancePromptContext): IAIFinancialAnalysisResult {
    return {
      summary: `Analyzed ${context.expenses.length} expenses and ${context.incomes.length} income sources.`,
      strengths: ['Consistent income streams logged', 'Active budget maintained'],
      weaknesses: context.totalExpenses > context.totalIncome ? ['Expenses exceed total income'] : ['High proportion spent on dining'],
      recommendations: [
        {
          title: 'Optimize Dining Out',
          description: 'Reduce weekly restaurant visits by 1 to save ~$40 monthly.',
          priority: 'HIGH',
          category: 'Food & Dining',
          potentialSavings: 40,
        },
      ],
      warnings: context.totalExpenses > context.totalIncome ? ['Negative cash flow detected for period'] : [],
      confidenceScore: 0.85,
    };
  }

  private getFallbackPrediction(context: IAIFinancePromptContext): IAIMonthEndPredictionResult {
    const days = Math.max(1, context.daysRemainingInMonth);
    const dailyAvg = context.expenses.length > 0 ? context.totalExpenses / Math.max(1, 30 - days) : 15;
    const projectedAddlSpent = dailyAvg * days;
    const expectedTotal = context.totalExpenses + projectedAddlSpent;
    const planned = context.budget ? Number(context.budget.plannedAmount) : 500;
    const predictedBalance = planned - expectedTotal;

    return {
      predictedMonthEndBalance: parseFloat(predictedBalance.toFixed(2)),
      expectedTotalSpending: parseFloat(expectedTotal.toFixed(2)),
      savingsAchievementProbability: predictedBalance >= 0 ? 85.0 : 35.0,
      budgetExhaustionDate: predictedBalance < 0 ? new Date().toISOString().split('T')[0] : null,
      reasoning: `Based on average daily spending of $${dailyAvg.toFixed(2)} across ${days} remaining days.`,
      confidenceScore: 0.85,
    };
  }

  private getFallbackSafeDailyBudget(context: IAIFinancePromptContext): IAISafeDailyBudgetResult {
    const days = Math.max(1, context.daysRemainingInMonth);
    const remBudget = Math.max(0, context.remainingBudget);
    const reservedSavings = 50;
    const safeDaily = Math.max(0, (remBudget - reservedSavings) / days);

    return {
      safeDailyLimit: parseFloat(safeDaily.toFixed(2)),
      remainingBudget: remBudget,
      remainingDays: days,
      reservedSavings,
      plannedUpcomingExpenses: 0,
      mathematicalReasoning: `Safe Daily Limit = (Remaining Budget $${remBudget.toFixed(2)} - Reserved Savings $${reservedSavings}) / ${days} days = $${safeDaily.toFixed(2)}/day.`,
      behavioralGuidance: ['Pace discretionary purchases to stay within daily limit.'],
      confidenceScore: 0.9,
    };
  }

  private getFallbackSavingsPlan(context: IAIFinancePromptContext): IAISavingsPlanResult {
    return {
      title: 'Student Savings Accelerator Plan',
      strategy: 'Automate recurring monthly transfer of 10% income into savings.',
      suggestedMonthlyContribution: parseFloat((context.totalIncome * 0.1).toFixed(2)),
      targetCategoriesToCut: ['Entertainment', 'Food & Dining'],
      emergencyFundAdvice: 'Maintain at least $300 in emergency reserve.',
      actionSteps: [
        { step: 1, title: 'Set automatic transfer', description: 'Schedule recurring deposit on income receipt date.' },
        { step: 2, title: 'Review active subscriptions', description: 'Cancel unused software or streaming apps.' },
      ],
      confidenceScore: 0.88,
    };
  }

  private getFallbackExpenseForecast(context: IAIFinancePromptContext): IAIExpenseForecastResult {
    const recurring = context.expenses.filter((e) => e.isRecurring);
    const items = recurring.map((e) => ({
      title: e.title,
      categoryName: e.category ? e.category.name : 'General',
      forecastedAmount: Number(e.amount),
      forecastDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      confidence: 0.9,
    }));

    const total = items.reduce((sum, i) => sum + i.forecastedAmount, 0);
    return {
      forecastedItems: items,
      totalForecastedAmount: total,
      summary: `Forecasted ${items.length} upcoming recurring expenses.`,
      confidenceScore: 0.85,
    };
  }
}
