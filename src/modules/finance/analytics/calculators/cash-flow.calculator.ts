import { Expense } from '../../entities/expense.entity';
import { Income } from '../../entities/income.entity';
import { FinanceDateUtils } from '../../utils/finance-date.utils';

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
    const curr = FinanceDateUtils.getStartOfDay(startDate);
    const end = FinanceDateUtils.getStartOfDay(endDate);
    while (curr <= end) {
      const dateStr = FinanceDateUtils.formatDate(curr);
      dayMap[dateStr] = { inflow: 0, outflow: 0 };
      curr.setDate(curr.getDate() + 1);
    }

    let totalInflow = 0;
    incomes.forEach((inc) => {
      const amt = Number(inc.amount);
      totalInflow += amt;
      const dStr = FinanceDateUtils.formatDate(new Date(inc.receivedDate));
      if (dayMap[dStr]) {
        dayMap[dStr].inflow += amt;
      }
    });

    let totalOutflow = 0;
    expenses.forEach((exp) => {
      const amt = Number(exp.amount);
      totalOutflow += amt;
      const dStr = FinanceDateUtils.formatDate(new Date(exp.expenseDate));
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

    const dailyBreakdown: IDailyCashFlowPoint[] = Object.entries(dayMap)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([date, data]) => ({
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

  static calculateYearlyCashFlow(
    incomes: Income[],
    expenses: Expense[],
    year: number,
  ): ICashFlowCalculationResult {
    const monthMap: Record<string, { inflow: number; outflow: number }> = {};

    for (let m = 0; m < 12; m++) {
      const key = `${year}-${String(m + 1).padStart(2, '0')}`;
      monthMap[key] = { inflow: 0, outflow: 0 };
    }

    let totalInflow = 0;
    incomes.forEach((inc) => {
      const amt = Number(inc.amount);
      totalInflow += amt;
      const d = new Date(inc.receivedDate);
      if (d.getFullYear() === year) {
        const key = `${year}-${String(d.getMonth() + 1).padStart(2, '0')}`;
        if (monthMap[key]) {
          monthMap[key].inflow += amt;
        }
      }
    });

    let totalOutflow = 0;
    expenses.forEach((exp) => {
      const amt = Number(exp.amount);
      totalOutflow += amt;
      const d = new Date(exp.expenseDate);
      if (d.getFullYear() === year) {
        const key = `${year}-${String(d.getMonth() + 1).padStart(2, '0')}`;
        if (monthMap[key]) {
          monthMap[key].outflow += amt;
        }
      }
    });

    totalInflow = parseFloat(totalInflow.toFixed(2));
    totalOutflow = parseFloat(totalOutflow.toFixed(2));
    const netCashFlow = parseFloat((totalInflow - totalOutflow).toFixed(2));

    const dailyAverageInflow = parseFloat((totalInflow / 365).toFixed(2));
    const dailyAverageOutflow = parseFloat((totalOutflow / 365).toFixed(2));
    const projectedEndBalance = netCashFlow;

    const dailyBreakdown: IDailyCashFlowPoint[] = Object.entries(monthMap)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([date, data]) => ({
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
