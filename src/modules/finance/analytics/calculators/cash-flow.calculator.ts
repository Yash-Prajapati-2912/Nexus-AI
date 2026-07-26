import { Expense } from '../../entities/expense.entity';
import { Income } from '../../entities/income.entity';

export interface IDailyCashFlowPoint {
  date: string; // YYYY-MM-DD
  inflow: number;
  outflow: number;
  net: number;
}

export interface ICashFlowCalculationResult {
  totalInflow: number;
  totalOutflow: number;
  netCashFlow: number;
  dailyAverageInflow: number;
  dailyAverageOutflow: number;
  projectedEndBalance: number;
  dailyBreakdown: IDailyCashFlowPoint[];
}

export class CashFlowCalculator {
  static calculateCashFlow(
    incomes: Income[],
    expenses: Expense[],
    startDate: Date,
    endDate: Date,
  ): ICashFlowCalculationResult {
    const dayMap: Record<string, { inflow: number; outflow: number }> = {};

    // Initialize all dates in range
    const curr = new Date(startDate);
    while (curr <= endDate) {
      const dateStr = curr.toISOString().split('T')[0];
      dayMap[dateStr] = { inflow: 0, outflow: 0 };
      curr.setUTCDate(curr.getUTCDate() + 1);
    }

    let totalInflow = 0;
    incomes.forEach((inc) => {
      const amt = Number(inc.amount);
      totalInflow += amt;
      const dStr = new Date(inc.receivedDate).toISOString().split('T')[0];
      if (dayMap[dStr]) {
        dayMap[dStr].inflow += amt;
      }
    });

    let totalOutflow = 0;
    expenses.forEach((exp) => {
      const amt = Number(exp.amount);
      totalOutflow += amt;
      const dStr = new Date(exp.expenseDate).toISOString().split('T')[0];
      if (dayMap[dStr]) {
        dayMap[dStr].outflow += amt;
      }
    });

    totalInflow = parseFloat(totalInflow.toFixed(2));
    totalOutflow = parseFloat(totalOutflow.toFixed(2));
    const netCashFlow = parseFloat((totalInflow - totalOutflow).toFixed(2));

    const totalDays = Math.max(1, Object.keys(dayMap).length);
    const dailyAverageInflow = parseFloat((totalInflow / totalDays).toFixed(2));
    const dailyAverageOutflow = parseFloat((totalOutflow / totalDays).toFixed(2));

    // Linear projection to end of month / period
    const projectedEndBalance = parseFloat((netCashFlow + (dailyAverageInflow - dailyAverageOutflow) * 5).toFixed(2));

    const dailyBreakdown: IDailyCashFlowPoint[] = Object.entries(dayMap).map(([date, data]) => ({
      date,
      inflow: parseFloat(data.inflow.toFixed(2)),
      outflow: parseFloat(data.outflow.toFixed(2)),
      net: parseFloat((data.inflow - data.outflow).toFixed(2)),
    }));

    return {
      totalInflow,
      totalOutflow,
      netCashFlow,
      dailyAverageInflow,
      dailyAverageOutflow,
      projectedEndBalance,
      dailyBreakdown,
    };
  }
}
