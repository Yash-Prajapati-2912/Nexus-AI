/**
 * Budget operational status options.
 */
export enum BudgetStatus {
  DRAFT = 'DRAFT',
  ACTIVE = 'ACTIVE',
  EXCEEDED = 'EXCEEDED',
  CLOSED = 'CLOSED',
}

/**
 * Supported payment methods for transaction tracking.
 */
export enum PaymentMethod {
  CASH = 'CASH',
  CREDIT_CARD = 'CREDIT_CARD',
  DEBIT_CARD = 'DEBIT_CARD',
  BANK_TRANSFER = 'BANK_TRANSFER',
  UPI = 'UPI',
  OTHER = 'OTHER',
}

/**
 * Frequency schedule for income items.
 */
export enum IncomeFrequency {
  ONE_TIME = 'ONE_TIME',
  WEEKLY = 'WEEKLY',
  BI_WEEKLY = 'BI_WEEKLY',
  MONTHLY = 'MONTHLY',
  YEARLY = 'YEARLY',
}

/**
 * Priority levels for student savings goals.
 */
export enum SavingsPriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  URGENT = 'URGENT',
}

/**
 * Operational status for savings targets.
 */
export enum SavingsStatus {
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
  CANCELLED = 'CANCELLED',
  PAUSED = 'PAUSED',
}

/**
 * Date range filter presets for financial querying.
 */
export enum DateRangePreset {
  TODAY = 'TODAY',
  THIS_WEEK = 'THIS_WEEK',
  THIS_MONTH = 'THIS_MONTH',
  CUSTOM = 'CUSTOM',
}

/**
 * Sorting keys supported for expense queries.
 */
export enum ExpenseSortBy {
  DATE = 'date',
  AMOUNT = 'amount',
  CATEGORY = 'category',
  MERCHANT = 'merchant',
  CREATED_AT = 'createdAt',
}
