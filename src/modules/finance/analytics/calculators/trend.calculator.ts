export interface ITrendCalculationInput {
  currentIncome: number;
  previousIncome: number;
  currentExpense: number;
  previousExpense: number;
  currentSavings: number;
  previousSavings: number;
  plannedBudget: number;
}

export interface ITrendCalculationResult {
  incomeGrowthPercentage: number;
  expenseGrowthPercentage: number;
  savingsGrowthPercentage: number;
  budgetConsumptionRate: number;
  netCashFlow: number;
}

export class TrendCalculator {
  static calculateGrowth(current: number, previous: number): number {
    if (previous === 0) {
      return current > 0 ? 100 : 0;
    }
    const growth = ((current - previous) / Math.abs(previous)) * 100;
    return parseFloat(growth.toFixed(2));
  }

  static calculateTrends(input: ITrendCalculationInput): ITrendCalculationResult {
    const incomeGrowthPercentage = this.calculateGrowth(input.currentIncome, input.previousIncome);
    const expenseGrowthPercentage = this.calculateGrowth(input.currentExpense, input.previousExpense);
    const savingsGrowthPercentage = this.calculateGrowth(input.currentSavings, input.previousSavings);

    const budgetConsumptionRate =
      input.plannedBudget > 0
        ? parseFloat(((input.currentExpense / input.plannedBudget) * 100).toFixed(2))
        : 0;

    const netCashFlow = parseFloat((input.currentIncome - input.currentExpense).toFixed(2));

    return {
      incomeGrowthPercentage,
      expenseGrowthPercentage,
      savingsGrowthPercentage,
      budgetConsumptionRate,
      netCashFlow,
    };
  }
}
