import { DateRangePreset, ExpenseSortBy, PaymentMethod } from '../constants/finance-enums.constants';

/**
 * Filter parameters for querying expenses.
 */
export interface IExpenseFilterOptions {
  search?: string;
  merchant?: string;
  categoryId?: string;
  dateRangePreset?: DateRangePreset;
  startDate?: string;
  endDate?: string;
  minAmount?: number;
  maxAmount?: number;
  tags?: string[];
  isRecurring?: boolean;
  paymentMethod?: PaymentMethod;
  sortBy?: ExpenseSortBy;
  sortOrder?: 'ASC' | 'DESC';
  page?: number;
  limit?: number;
}
