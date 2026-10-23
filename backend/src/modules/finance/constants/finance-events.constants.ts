/**
 * Finance Event Name Constants for EventEmitter2 bus.
 */
export const FINANCE_EVENTS = {
  BUDGET_CREATED: 'finance.budget.created',
  EXPENSE_ADDED: 'finance.expense.added',
  EXPENSE_DELETED: 'finance.expense.deleted',
  INCOME_ADDED: 'finance.income.added',
  SAVINGS_GOAL_CREATED: 'finance.savings_goal.created',
  MONTHLY_SUMMARY_UPDATED: 'finance.monthly_summary.updated',
} as const;
