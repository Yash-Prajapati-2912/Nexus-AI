import { FinanceDateUtils } from '../utils/finance-date.utils';
import { CashFlowCalculator } from '../analytics/calculators/cash-flow.calculator';
import { Expense } from '../entities/expense.entity';
import { Income } from '../entities/income.entity';

describe('FinanceDateUtils (Backend)', () => {
  describe('Daily Boundaries', () => {
    it('should set start of day to 00:00:00.000', () => {
      const date = new Date(2026, 8, 30, 15, 30, 0); // Sept 30 2026
      const start = FinanceDateUtils.getStartOfDay(date);
      expect(start.getHours()).toBe(0);
      expect(start.getMinutes()).toBe(0);
      expect(start.getSeconds()).toBe(0);
      expect(start.getMilliseconds()).toBe(0);
      expect(start.getDate()).toBe(30);
      expect(start.getMonth()).toBe(8);
      expect(start.getFullYear()).toBe(2026);
    });

    it('should set end of day to 23:59:59.999', () => {
      const date = new Date(2026, 8, 30, 15, 30, 0);
      const end = FinanceDateUtils.getEndOfDay(date);
      expect(end.getHours()).toBe(23);
      expect(end.getMinutes()).toBe(59);
      expect(end.getSeconds()).toBe(59);
      expect(end.getMilliseconds()).toBe(999);
      expect(end.getDate()).toBe(30);
    });

    it('should accurately detect midnight 00:00:00 in range', () => {
      const start = FinanceDateUtils.getStartOfDay(new Date(2026, 9, 1));
      const end = FinanceDateUtils.getEndOfDay(new Date(2026, 9, 1));
      const midnight = new Date(2026, 9, 1, 0, 0, 0, 0);
      expect(FinanceDateUtils.isDateInRange(midnight, start, end)).toBe(true);

      const prevDayEnd = new Date(2026, 8, 30, 23, 59, 59, 999);
      expect(FinanceDateUtils.isDateInRange(prevDayEnd, start, end)).toBe(false);
    });

    it('should accurately detect 23:59:59 in range', () => {
      const start = FinanceDateUtils.getStartOfDay(new Date(2026, 8, 30));
      const end = FinanceDateUtils.getEndOfDay(new Date(2026, 8, 30));
      const nearMidnight = new Date(2026, 8, 30, 23, 59, 59, 500);
      expect(FinanceDateUtils.isDateInRange(nearMidnight, start, end)).toBe(true);
    });
  });

  describe('Weekly Boundaries (Monday to Sunday)', () => {
    it('should return Monday 00:00:00 for any day in the week', () => {
      // 2026-09-30 is Wednesday
      const wednesday = new Date(2026, 8, 30, 12, 0, 0);
      const monday = FinanceDateUtils.getStartOfWeek(wednesday);
      expect(monday.getDay()).toBe(1); // Monday
      expect(monday.getDate()).toBe(28);
      expect(monday.getMonth()).toBe(8);

      const sunday = FinanceDateUtils.getEndOfWeek(wednesday);
      expect(sunday.getDay()).toBe(0); // Sunday
      expect(sunday.getDate()).toBe(4);
      expect(sunday.getMonth()).toBe(9); // Oct 4
      expect(sunday.getHours()).toBe(23);
      expect(sunday.getMinutes()).toBe(59);
    });

    it('should handle week crossing year boundary', () => {
      // 2026-12-31 is Thursday
      const thursday = new Date(2026, 11, 31, 10, 0, 0);
      const monday = FinanceDateUtils.getStartOfWeek(thursday);
      const sunday = FinanceDateUtils.getEndOfWeek(thursday);

      expect(monday.getFullYear()).toBe(2026);
      expect(monday.getMonth()).toBe(11);
      expect(monday.getDate()).toBe(28);

      expect(sunday.getFullYear()).toBe(2027);
      expect(sunday.getMonth()).toBe(0); // January
      expect(sunday.getDate()).toBe(3);
    });
  });

  describe('Monthly Boundaries', () => {
    it('should handle 28-day February for non-leap year', () => {
      const start = FinanceDateUtils.getStartOfMonth(2026, 2);
      const end = FinanceDateUtils.getEndOfMonth(2026, 2);
      expect(start.getDate()).toBe(1);
      expect(end.getDate()).toBe(28);
      expect(end.getMonth()).toBe(1); // Feb is 1
    });

    it('should handle 29-day February for leap year', () => {
      const end = FinanceDateUtils.getEndOfMonth(2024, 2);
      expect(end.getDate()).toBe(29);
      expect(end.getMonth()).toBe(1);
    });

    it('should handle 30-day and 31-day months', () => {
      expect(FinanceDateUtils.getEndOfMonth(2026, 9).getDate()).toBe(30); // September
      expect(FinanceDateUtils.getEndOfMonth(2026, 10).getDate()).toBe(31); // October
    });
  });

  describe('Yearly Boundaries', () => {
    it('should handle Jan 1 00:00:00 to Dec 31 23:59:59', () => {
      const start = FinanceDateUtils.getStartOfYear(2026);
      const end = FinanceDateUtils.getEndOfYear(2026);
      expect(start.getMonth()).toBe(0);
      expect(start.getDate()).toBe(1);
      expect(end.getMonth()).toBe(11);
      expect(end.getDate()).toBe(31);
      expect(end.getHours()).toBe(23);
      expect(end.getMinutes()).toBe(59);
    });
  });

  describe('Date Parsing and Formatting', () => {
    it('should parse YYYY-MM-DD startDate to 00:00:00', () => {
      const parsed = FinanceDateUtils.parseStartDate('2026-09-01');
      expect(parsed.getHours()).toBe(0);
      expect(parsed.getMinutes()).toBe(0);
      expect(parsed.getDate()).toBe(1);
      expect(parsed.getMonth()).toBe(8);
    });

    it('should parse YYYY-MM-DD endDate to 23:59:59.999', () => {
      const parsed = FinanceDateUtils.parseEndDate('2026-09-30');
      expect(parsed.getHours()).toBe(23);
      expect(parsed.getMinutes()).toBe(59);
      expect(parsed.getSeconds()).toBe(59);
      expect(parsed.getMilliseconds()).toBe(999);
      expect(parsed.getDate()).toBe(30);
      expect(parsed.getMonth()).toBe(8);
    });

    it('should format date using local calendar date without timezone shift', () => {
      const date = new Date(2026, 8, 30, 23, 30, 0);
      expect(FinanceDateUtils.formatDate(date)).toBe('2026-09-30');
    });
  });

  describe('CashFlowCalculator Continuous Timeline and Sorting', () => {
    it('should fill empty days with 0.0 and sort chronologically', () => {
      const startDate = new Date(2026, 8, 28, 0, 0, 0);
      const endDate = new Date(2026, 8, 30, 23, 59, 59);

      const incomes: Income[] = [
        {
          id: 'i1',
          userId: 'u1',
          source: 'Salary',
          amount: 500,
          receivedDate: new Date(2026, 8, 28, 10, 0, 0),
        } as Income,
      ];

      const expenses: Expense[] = [
        {
          id: 'e1',
          userId: 'u1',
          title: 'Dinner',
          amount: 100,
          expenseDate: new Date(2026, 8, 30, 21, 0, 0),
        } as Expense,
      ];

      const result = CashFlowCalculator.calculateCashFlow(incomes, expenses, startDate, endDate);

      expect(result.dailyBreakdown.length).toBe(3);
      expect(result.dailyBreakdown[0].date).toBe('2026-09-28');
      expect(result.dailyBreakdown[0].inflow).toBe(500);
      expect(result.dailyBreakdown[0].outflow).toBe(0);

      // Sept 29 is empty and preserved with 0
      expect(result.dailyBreakdown[1].date).toBe('2026-09-29');
      expect(result.dailyBreakdown[1].inflow).toBe(0);
      expect(result.dailyBreakdown[1].outflow).toBe(0);
      expect(result.dailyBreakdown[1].net).toBe(0);

      expect(result.dailyBreakdown[2].date).toBe('2026-09-30');
      expect(result.dailyBreakdown[2].inflow).toBe(0);
      expect(result.dailyBreakdown[2].outflow).toBe(100);
      expect(result.dailyBreakdown[2].net).toBe(-100);
    });
  });
});
