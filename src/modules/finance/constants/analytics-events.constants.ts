/**
 * Financial Analytics & Reporting Event Name Constants for EventEmitter bus.
 */
export const ANALYTICS_EVENTS = {
  REPORT_GENERATED: 'finance.analytics.report_generated',
  BUDGET_THRESHOLD_REACHED: 'finance.analytics.budget_threshold_reached',
  CASH_FLOW_UPDATED: 'finance.analytics.cash_flow_updated',
  CATEGORY_ANALYTICS_UPDATED: 'finance.analytics.category_updated',
  TREND_CALCULATED: 'finance.analytics.trend_calculated',
} as const;
