import { IAIFinancePromptContext } from '../interfaces/ai-finance-prompt-context.interface';
import { PromptSanitizerBuilder } from './prompt-sanitizer.builder';
import { FinanceDateUtils } from '../../utils/finance-date.utils';

export class FinancePromptBuilder {
  private context!: IAIFinancePromptContext;
  private taskType: string = 'FINANCIAL_ANALYSIS';
  private extraInstructions: string = '';

  setContext(context: IAIFinancePromptContext): this {
    this.context = context;
    return this;
  }

  setTaskType(taskType: string): this {
    this.taskType = taskType;
    return this;
  }

  setExtraInstructions(instructions?: string): this {
    if (instructions) {
      this.extraInstructions = PromptSanitizerBuilder.sanitizeText(instructions);
    }
    return this;
  }

  build(): string {
    const curr = this.context.currencySymbol || '₹';

    const budgetInfo = this.context.budget
      ? `Monthly Budget Limit: ${curr}${this.context.budget.plannedAmount}
Budget Spent: ${curr}${this.context.budget.spentAmount}
Budget Remaining: ${curr}${this.context.remainingBudget}
Budget Usage: ${this.context.budgetUsagePercentage ?? 0}%
Normal Daily Budget: ${curr}${this.context.normalDailyBudget ?? 0}/day
Safe to Spend / Remaining Day: ${curr}${this.context.safeDailyLimit ?? 0}/day
Projected Month-End Spending: ${curr}${this.context.projectedMonthEnd ?? 0}`
      : `No active monthly budget configured.
Safe to Spend / Remaining Day: ${curr}${this.context.safeDailyLimit ?? 0}/day
Projected Month-End Spending: ${curr}${this.context.projectedMonthEnd ?? 0}`;

    const categorySummary = this.context.categoryBreakdown && this.context.categoryBreakdown.length > 0
      ? this.context.categoryBreakdown
          .map((c) => `- ${c.categoryName}: ${curr}${c.totalSpent ?? c.totalAmount ?? 0} (${c.percentage.toFixed(1)}%)`)
          .join('\n')
      : 'No categorized spending recorded.';

    const expensesSummary = this.context.expenses
      .slice(0, 15)
      .map((e) => {
        const d = e.expenseDate ? FinanceDateUtils.formatDate(new Date(e.expenseDate)) : 'N/A';
        const cat = e.category ? e.category.name : 'General';
        return `- ${d}: ${PromptSanitizerBuilder.sanitizeText(e.title)} (${curr}${e.amount}) [${cat}]`;
      })
      .join('\n');

    const incomesSummary = this.context.incomes
      .slice(0, 10)
      .map((i) => {
        const d = i.receivedDate ? FinanceDateUtils.formatDate(new Date(i.receivedDate)) : 'N/A';
        return `- ${d}: ${PromptSanitizerBuilder.sanitizeText(i.source)} (${curr}${i.amount}) [${i.frequency}]`;
      })
      .join('\n');

    const savingsSummary = this.context.savingsGoals
      .map((s) => {
        const target = Number(s.targetAmount);
        const current = Number(s.currentAmount);
        const remaining = Math.max(0, target - current);
        const progress = target > 0 ? ((current / target) * 100).toFixed(1) : '0.0';
        const d = s.targetDate ? FinanceDateUtils.formatDate(new Date(s.targetDate)) : 'No deadline';
        return `- ${PromptSanitizerBuilder.sanitizeText(s.title)}: Target ${curr}${target}, Current ${curr}${current}, Remaining ${curr}${remaining} (${progress}% achieved), Deadline ${d}`;
      })
      .join('\n');

    return `
Task: ${this.taskType}
Reporting Period: Current Calendar Month (${this.context.daysRemainingInMonth} days remaining out of ${this.context.totalDaysInMonth || 30} days, ${this.context.elapsedDays || 0} days elapsed)

[Confirmed Financial Facts]
Total Recorded Inflow: ${curr}${this.context.totalIncome}
Total Recorded Outflow: ${curr}${this.context.totalExpenses}
Net Recorded Balance: ${curr}${this.context.netBalance ?? (this.context.totalIncome - this.context.totalExpenses)}
${budgetInfo}

[Category Breakdown (Confirmed)]
${categorySummary}

[Recent Recorded Incomes (Confirmed)]
${incomesSummary || 'No recent incomes logged.'}

[Recent Recorded Expenses (Confirmed)]
${expensesSummary || 'No recent expenses logged.'}

[Savings Targets (Confirmed)]
${savingsSummary || 'No active savings goals.'}

[AI Guidance Directives]
1. Ground all analysis strictly in the confirmed financial facts above. Never invent, hallucinate, or assume any transactions, amounts, balances, or merchants.
2. If only one month of data exists, explicitly treat the analysis as a current-month snapshot rather than a multi-year historical trend.
3. Clearly distinguish confirmed facts (e.g., recorded spending) from AI observations and suggestions.
4. When recommending savings: Reason using confirmed figures: "Your recorded income is ${curr}X and expenses are ${curr}Y, leaving approximately ${curr}Z before other commitments."
5. For savings goals: Use the confirmed target, current, and remaining amounts (Remaining = Target - Current). Provide realistic periodic contribution timelines. Never modify financial records automatically.
6. For emergency reserves: Base recommendations on recorded essential monthly spending when available (e.g. 3-month reserve = 3 * monthly essential expenses).
7. When discussing investments or extra cash: Provide educational, goal-based options by time horizon (short-term liquidity, medium-term capital preservation, long-term diversified growth). NEVER claim guaranteed returns, NEVER recommend specific stock/crypto tickers, and clearly state that live market data is not available.
8. If data is insufficient or zero records exist, explicitly state that available data is insufficient instead of fabricating numbers or transactions.

Structure your analysis using clean markdown sections:
### Summary
Short explanation of current financial situation based on real data.

### What I noticed
2-4 data-based observations grounded in category percentages and budget usage.

### What you could do
2-4 practical suggestions with potential discretionary reductions.

### If you want to save/invest
Educational allocation considerations based on liquidity, goals, timeframe, and risk.

${this.extraInstructions ? `[User Specific Query / Request]\n${this.extraInstructions}` : ''}
`.trim();
  }
}
