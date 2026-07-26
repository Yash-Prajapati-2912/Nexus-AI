import { IAIFinancePromptContext } from '../interfaces/ai-finance-prompt-context.interface';
import { PromptSanitizerBuilder } from './prompt-sanitizer.builder';

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
    const budgetInfo = this.context.budget
      ? `Monthly Budget: Planned $${this.context.budget.plannedAmount}, Spent $${this.context.budget.spentAmount}, Remaining $${this.context.budget.remainingAmount}`
      : 'No active monthly budget configured.';

    const expensesSummary = this.context.expenses
      .slice(0, 15)
      .map((e) => `- ${e.expenseDate.toISOString().split('T')[0]}: ${PromptSanitizerBuilder.sanitizeText(e.title)} ($${e.amount}) [${e.category ? e.category.name : 'General'}]`)
      .join('\n');

    const incomesSummary = this.context.incomes
      .slice(0, 10)
      .map((i) => `- ${i.receivedDate.toISOString().split('T')[0]}: ${PromptSanitizerBuilder.sanitizeText(i.source)} ($${i.amount}) [${i.frequency}]`)
      .join('\n');

    const savingsSummary = this.context.savingsGoals
      .map((s) => `- ${PromptSanitizerBuilder.sanitizeText(s.title)}: Target $${s.targetAmount}, Current $${s.currentAmount}, Deadline ${s.targetDate.toISOString().split('T')[0]}`)
      .join('\n');

    return `
Task: ${this.taskType}
User ID: ${this.context.userId}
Days Remaining in Month: ${this.context.daysRemainingInMonth}

[Financial Summary]
Total Inflow: $${this.context.totalIncome}
Total Outflow: $${this.context.totalExpenses}
Remaining Budget: $${this.context.remainingBudget}
${budgetInfo}

[Recent Incomes]
${incomesSummary || 'No recent incomes logged.'}

[Recent Expenses]
${expensesSummary || 'No recent expenses logged.'}

[Savings Targets]
${savingsSummary || 'No active savings goals.'}

${this.extraInstructions ? `[Extra User Requirements]\n${this.extraInstructions}` : ''}
`.trim();
  }
}
