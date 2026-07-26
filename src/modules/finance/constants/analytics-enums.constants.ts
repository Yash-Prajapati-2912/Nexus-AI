/**
 * Supported periods for financial analytics aggregations.
 */
export enum AnalyticsPeriod {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
  YEARLY = 'YEARLY',
  CUSTOM = 'CUSTOM',
}

/**
 * Key identifiers for core financial metrics.
 */
export enum MetricKey {
  BUDGET_ACCURACY = 'BUDGET_ACCURACY',
  EXPENSE_FREQUENCY = 'EXPENSE_FREQUENCY',
  SAVINGS_PROGRESS = 'SAVINGS_PROGRESS',
  AVG_TRANSACTION_VALUE = 'AVG_TRANSACTION_VALUE',
  MOST_ACTIVE_SPENDING_DAY = 'MOST_ACTIVE_SPENDING_DAY',
  MOST_ACTIVE_CATEGORY = 'MOST_ACTIVE_CATEGORY',
}

/**
 * Types of budget and financial alert triggers.
 */
export enum AlertType {
  BUDGET_50_PERCENT = 'BUDGET_50_PERCENT',
  BUDGET_75_PERCENT = 'BUDGET_75_PERCENT',
  BUDGET_90_PERCENT = 'BUDGET_90_PERCENT',
  BUDGET_EXCEEDED = 'BUDGET_EXCEEDED',
  SAVINGS_GOAL_NEAR_COMPLETION = 'SAVINGS_GOAL_NEAR_COMPLETION',
  SAVINGS_GOAL_MISSED = 'SAVINGS_GOAL_MISSED',
}

/**
 * Types of financial reports.
 */
export enum ReportType {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
  QUARTERLY = 'QUARTERLY',
  YEARLY = 'YEARLY',
  CUSTOM = 'CUSTOM',
}

/**
 * Export output formats.
 */
export enum ExportFormat {
  JSON = 'JSON',
  CSV = 'CSV',
  EXCEL = 'EXCEL',
  PDF = 'PDF',
}

/**
 * Date range filter presets for analytics queries.
 */
export enum AnalyticsDatePreset {
  TODAY = 'TODAY',
  YESTERDAY = 'YESTERDAY',
  THIS_WEEK = 'THIS_WEEK',
  LAST_WEEK = 'LAST_WEEK',
  THIS_MONTH = 'THIS_MONTH',
  LAST_MONTH = 'LAST_MONTH',
  CUSTOM = 'CUSTOM',
}
