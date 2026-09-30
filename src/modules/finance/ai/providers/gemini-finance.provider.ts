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
Analyze the student's actual confirmed financial data provided in the prompt.
CRITICAL RULES:
1. Ground your entire analysis strictly in the confirmed financial facts provided.
2. DO NOT fabricate, hallucinate, or assume any transactions, amounts, balances, or merchants.
3. Distinguish confirmed facts ("Your recorded expenses this month are...") from AI analysis/suggestions ("Consider setting a limit on...").
4. If available data is insufficient or zero transactions exist, explicitly state in the summary that available data is insufficient instead of inventing details.
5. Respect actual category names and actual budget values. Do not invent mock categories.
Output ONLY a valid JSON object matching this exact schema:
{
  "summary": "Executive summary of financial situation",
  "strengths": ["Confirmed strength 1", "Confirmed strength 2"],
  "weaknesses": ["Spending area to watch"],
  "recommendations": [
    {
      "title": "Actionable recommendation title",
      "description": "Clear guidance based on confirmed data",
      "priority": "HIGH",
      "category": "Actual category name from data or General",
      "potentialSavings": 0
    }
  ],
  "warnings": ["Warning if overspending or approaching budget limit"],
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
Base your prediction strictly on the confirmed financial data and days remaining in the month.
CRITICAL RULES:
1. Ground prediction in actual recorded spending velocity and confirmed income/budget.
2. If zero expenses are recorded, state that transaction history is insufficient to estimate burn rate.
3. Do not invent imaginary future expenses.
Output ONLY a valid JSON object matching:
{
  "predictedMonthEndBalance": 0.0,
  "expectedTotalSpending": 0.0,
  "savingsAchievementProbability": 85.0,
  "budgetExhaustionDate": null,
  "reasoning": "Mathematical explanation based strictly on confirmed numbers",
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
Calculate safe daily spending strictly from confirmed remaining budget (or net balance) divided by days remaining.
CRITICAL RULES:
1. Use the actual remaining budget or net balance provided. Do not invent a different remaining amount.
2. Use the exact remaining days in the month provided.
3. Show transparent mathematical reasoning: Safe Limit = Remaining / Days Remaining.
Output ONLY a valid JSON object matching:
{
  "safeDailyLimit": 0.0,
  "remainingBudget": 0.0,
  "remainingDays": 14,
  "reservedSavings": 0.0,
  "plannedUpcomingExpenses": 0.0,
  "mathematicalReasoning": "Formula and numbers used",
  "behavioralGuidance": ["Actionable guidance tailored to real spending"],
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
Formulate a realistic savings strategy strictly based on the confirmed income, expenses, and savings goals provided.
CRITICAL RULES:
1. Do not invent arbitrary debt, subscriptions, or income that the user has not logged.
2. Reference actual goals and top expense categories from the prompt.
3. If no income or goals exist, guide the user to set up their first financial goal.
Output ONLY a valid JSON object matching:
{
  "title": "Savings plan title",
  "strategy": "Actionable savings strategy",
  "suggestedMonthlyContribution": 0.0,
  "targetCategoriesToCut": ["Actual category from prompt"],
  "emergencyFundAdvice": "Context-aware safety fund advice",
  "actionSteps": [
    { "step": 1, "title": "Step title", "description": "Actionable instruction" }
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
Forecast future commitments strictly using confirmed recurring expenses or confirmed historical spending rates.
CRITICAL RULES:
1. Only project recurring expenses that actually appear in the prompt data.
2. If no recurring expenses exist, return an empty forecastedItems list and 0 total.
3. Do not invent sample bills like Wi-Fi or streaming unless explicitly logged.
Output ONLY a valid JSON object matching:
{
  "forecastedItems": [
    { "title": "Expense Title", "categoryName": "Category", "forecastedAmount": 0.0, "forecastDate": "YYYY-MM-DD", "confidence": 0.9 }
  ],
  "totalForecastedAmount": 0.0,
  "summary": "Explanation of forecasted recurring commitments",
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
    const hasData = context.expenses.length > 0 || context.incomes.length > 0;
    const curr = context.currencySymbol || '$';

    if (!hasData) {
      return {
        summary: 'Insufficient finance data. No recorded income or expense transactions found for this period.',
        strengths: [],
        weaknesses: [],
        recommendations: [
          {
            title: 'Log Your First Transaction',
            description: 'Record your daily expenses and income in Finance Studio to unlock personalized AI insights.',
            priority: 'HIGH' as const,
            category: 'General',
            potentialSavings: 0,
          },
        ],
        warnings: [],
        confidenceScore: 0.85,
      };
    }

    const net = context.netBalance ?? (context.totalIncome - context.totalExpenses);
    const topCat = context.categoryBreakdown && context.categoryBreakdown.length > 0
      ? context.categoryBreakdown[0]
      : null;

    const strengths: string[] = [];
    if (context.incomes.length > 0) strengths.push(`Recorded inflow: ${curr}${context.totalIncome}`);
    if (net > 0) strengths.push(`Positive net balance of ${curr}${net.toFixed(2)}`);
    if (context.budget && Number(context.budget.spentAmount) <= Number(context.budget.plannedAmount)) {
      strengths.push('Spending is within planned monthly budget limit');
    }

    const weaknesses: string[] = [];
    if (net < 0) weaknesses.push(`Expenses exceed income by ${curr}${Math.abs(net).toFixed(2)}`);
    if (topCat && topCat.percentage > 40) {
      weaknesses.push(`${topCat.categoryName} represents ${topCat.percentage.toFixed(0)}% of total expenses`);
    }

    const warnings: string[] = [];
    if (context.budget && Number(context.budget.spentAmount) > Number(context.budget.plannedAmount)) {
      warnings.push(`Monthly budget exceeded by ${curr}${(Number(context.budget.spentAmount) - Number(context.budget.plannedAmount)).toFixed(2)}`);
    }

    const recommendations = [];
    if (topCat) {
      const topAmount = topCat.totalSpent ?? topCat.totalAmount ?? 0;
      recommendations.push({
        title: `Optimize ${topCat.categoryName}`,
        description: `Your highest spending category is ${topCat.categoryName} (${curr}${topAmount}). Consider setting a category limit.`,
        priority: 'HIGH' as const,
        category: topCat.categoryName,
        potentialSavings: Math.round(topAmount * 0.1),
      });
    } else {
      recommendations.push({
        title: 'Categorize Your Expenses',
        description: 'Assign categories to your expenses to unlock detailed AI category spending analysis.',
        priority: 'MEDIUM' as const,
        category: 'General',
        potentialSavings: 0,
      });
    }

    const emergencyReserve = (context.totalExpenses * 3).toFixed(0);
    const structuredSummary = `### Summary
Your recorded income is ${curr}${context.totalIncome} and recorded expenses are ${curr}${context.totalExpenses}, leaving a net balance of ${curr}${net.toFixed(2)} before other commitments.

### What I noticed
${strengths.length > 0 ? strengths.map((s) => `- ${s}`).join('\n') : '- Transactions recorded for this period.'}
${weaknesses.length > 0 ? weaknesses.map((w) => `- ${w}`).join('\n') : '- Spending is distributed across categories.'}

### What you could do
${recommendations.map((r) => `- ${r.title}: ${r.description} (Potential monthly savings: ${curr}${r.potentialSavings || 0})`).join('\n')}

### If you want to save/invest
- Maintain an emergency reserve of approximately ${curr}${emergencyReserve} (covering 3 months of essential expenses).
- Short-term allocations: prioritize capital preservation and liquidity.
- Medium to long-term goals: consider diversified, goal-based investment options appropriate to your time horizon and risk tolerance.`;

    return {
      summary: structuredSummary,
      strengths: strengths.length > 0 ? strengths : ['Transaction records active'],
      weaknesses,
      recommendations,
      warnings,
      confidenceScore: 0.85,
    };
  }

  private getFallbackPrediction(context: IAIFinancePromptContext): IAIMonthEndPredictionResult {
    const days = Math.max(1, context.daysRemainingInMonth);
    const curr = context.currencySymbol || '$';

    if (context.expenses.length === 0) {
      return {
        predictedMonthEndBalance: parseFloat(context.totalIncome.toFixed(2)),
        expectedTotalSpending: 0,
        savingsAchievementProbability: context.totalIncome > 0 ? 100.0 : 0.0,
        budgetExhaustionDate: null,
        reasoning: `No expenses logged. Projected balance matches recorded inflow of ${curr}${context.totalIncome}.`,
        confidenceScore: 0.85,
      };
    }

    const dailyAvg = context.totalExpenses / Math.max(1, 30 - days);
    const projectedAddlSpent = dailyAvg * days;
    const expectedTotal = context.totalExpenses + projectedAddlSpent;
    const baseAmount = context.budget ? Number(context.budget.plannedAmount) : context.totalIncome;
    const predictedBalance = baseAmount - expectedTotal;

    return {
      predictedMonthEndBalance: parseFloat(predictedBalance.toFixed(2)),
      expectedTotalSpending: parseFloat(expectedTotal.toFixed(2)),
      savingsAchievementProbability: predictedBalance >= 0 ? 85.0 : 35.0,
      budgetExhaustionDate: predictedBalance < 0 ? new Date().toISOString().split('T')[0] : null,
      reasoning: `Based on recorded daily spending of ${curr}${dailyAvg.toFixed(2)} across ${days} remaining days.`,
      confidenceScore: 0.85,
    };
  }

  private getFallbackSafeDailyBudget(context: IAIFinancePromptContext): IAISafeDailyBudgetResult {
    const days = Math.max(1, context.daysRemainingInMonth);
    const curr = context.currencySymbol || '$';
    const remBudget = Math.max(0, context.remainingBudget);
    const safeDaily = days > 0 ? remBudget / days : 0;

    return {
      safeDailyLimit: parseFloat(safeDaily.toFixed(2)),
      remainingBudget: parseFloat(remBudget.toFixed(2)),
      remainingDays: days,
      reservedSavings: 0,
      plannedUpcomingExpenses: 0,
      mathematicalReasoning: `Safe Daily Limit = Remaining Budget ${curr}${remBudget.toFixed(2)} / ${days} days = ${curr}${safeDaily.toFixed(2)}/day.`,
      behavioralGuidance: [
        safeDaily > 0
          ? `Pace daily discretionary purchases within ${curr}${safeDaily.toFixed(2)}/day to stay within limits.`
          : 'Log additional income or adjust your budget to calculate a positive daily spending limit.',
      ],
      confidenceScore: 0.9,
    };
  }

  private getFallbackSavingsPlan(context: IAIFinancePromptContext): IAISavingsPlanResult {
    const curr = context.currencySymbol || '$';
    const net = context.netBalance ?? (context.totalIncome - context.totalExpenses);
    const suggested = Math.max(0, net > 0 ? net * 0.2 : context.totalIncome * 0.1);
    const topCat = context.categoryBreakdown && context.categoryBreakdown.length > 0
      ? context.categoryBreakdown[0].categoryName
      : null;

    if (context.savingsGoals.length > 0) {
      const primaryGoal = context.savingsGoals[0];
      const target = Number(primaryGoal.targetAmount);
      const current = Number(primaryGoal.currentAmount);
      const remaining = Math.max(0, target - current);

      return {
        title: `${primaryGoal.title} Acceleration Strategy`,
        strategy: `Allocate ${curr}${suggested.toFixed(0)} monthly towards ${primaryGoal.title}. Target is ${curr}${target} with ${curr}${remaining} remaining.`,
        suggestedMonthlyContribution: parseFloat(suggested.toFixed(2)),
        targetCategoriesToCut: topCat ? [topCat] : [],
        emergencyFundAdvice: `Prioritize reaching ${curr}${target} for ${primaryGoal.title}.`,
        actionSteps: [
          { step: 1, title: 'Consistent deposit', description: `Transfer ${curr}${suggested.toFixed(0)} when income is received.` },
        ],
        confidenceScore: 0.88,
      };
    }

    return {
      title: 'Personalized Savings Plan',
      strategy: context.totalIncome > 0
        ? `Allocate 10-20% of monthly income (${curr}${suggested.toFixed(0)}) into a designated savings goal.`
        : 'Record your regular income and expenses to establish an automated savings strategy.',
      suggestedMonthlyContribution: parseFloat(suggested.toFixed(2)),
      targetCategoriesToCut: topCat ? [topCat] : [],
      emergencyFundAdvice: 'Establish a one-month living expense reserve before discretionary spending.',
      actionSteps: [
        { step: 1, title: 'Create a savings goal', description: 'Create a dedicated savings goal in Finance Studio.' },
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
      summary: items.length > 0
        ? `Forecasted ${items.length} upcoming recurring expenses.`
        : 'No upcoming recurring commitments detected in your transaction records.',
      confidenceScore: 0.85,
    };
  }
}
