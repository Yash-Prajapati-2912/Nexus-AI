export class FinanceDateUtils {
  /**
   * Start of day (00:00:00.000).
   */
  static getStartOfDay(date: Date): Date {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0, 0);
  }

  /**
   * End of day (23:59:59.999).
   */
  static getEndOfDay(date: Date): Date {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59, 999);
  }

  /**
   * Monday 00:00:00.000 of the week containing the given date.
   * Handles weeks crossing months and years cleanly without mutating input.
   */
  static getStartOfWeek(date: Date): Date {
    const day = date.getDay(); // 0 is Sunday, 1 is Monday, ...
    const diffToMonday = day === 0 ? 6 : day - 1;
    return new Date(date.getFullYear(), date.getMonth(), date.getDate() - diffToMonday, 0, 0, 0, 0);
  }

  /**
   * Sunday 23:59:59.999 of the week containing the given date.
   */
  static getEndOfWeek(date: Date): Date {
    const monday = this.getStartOfWeek(date);
    return new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() + 6, 23, 59, 59, 999);
  }

  /**
   * 1st of month 00:00:00.000 (month is 1-indexed: 1 = Jan, 12 = Dec).
   */
  static getStartOfMonth(year: number, month: number): Date {
    return new Date(year, month - 1, 1, 0, 0, 0, 0);
  }

  /**
   * Last day of month 23:59:59.999.
   * Accurately handles 28-day Feb, leap years (29 days), 30-day and 31-day months.
   */
  static getEndOfMonth(year: number, month: number): Date {
    return new Date(year, month, 0, 23, 59, 59, 999);
  }

  /**
   * January 1 00:00:00.000.
   */
  static getStartOfYear(year: number): Date {
    return new Date(year, 0, 1, 0, 0, 0, 0);
  }

  /**
   * December 31 23:59:59.999.
   */
  static getEndOfYear(year: number): Date {
    return new Date(year, 11, 31, 23, 59, 59, 999);
  }

  /**
   * Normalizes a start date query parameter:
   * If a plain date string without time is provided (e.g. '2026-09-01'), sets time to 00:00:00.000.
   */
  static parseStartDate(value: string | Date): Date {
    if (typeof value === 'string' && value.length <= 10) {
      const parts = value.split('-').map((p) => parseInt(p, 10));
      if (parts.length === 3) {
        return new Date(parts[0], parts[1] - 1, parts[2], 0, 0, 0, 0);
      }
    }
    return new Date(value);
  }

  /**
   * Normalizes an end date query parameter:
   * If a plain date string without time is provided (e.g. '2026-09-30'), sets time to 23:59:59.999.
   */
  static parseEndDate(value: string | Date): Date {
    if (typeof value === 'string' && value.length <= 10) {
      const parts = value.split('-').map((p) => parseInt(p, 10));
      if (parts.length === 3) {
        return new Date(parts[0], parts[1] - 1, parts[2], 23, 59, 59, 999);
      }
    }
    return new Date(value);
  }

  /**
   * Formats a Date object to YYYY-MM-DD using local calendar year, month, and day.
   * Avoids timezone shifting that occurs with toISOString().
   */
  static formatDate(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  /**
   * Returns whether a date falls strictly within [start, end] inclusive.
   */
  static isDateInRange(date: Date, start: Date, end: Date): boolean {
    const time = date.getTime();
    return time >= start.getTime() && time <= end.getTime();
  }
}
