/**
 * AI Provider types supported by the AI Financial Engine.
 */
export enum AIProviderType {
  GEMINI = 'GEMINI',
  OPENAI = 'OPENAI',
  ANTHROPIC = 'ANTHROPIC',
  LOCAL = 'LOCAL',
}

/**
 * Priority levels for generated financial insights.
 */
export enum InsightPriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  CRITICAL = 'CRITICAL',
}

/**
 * Categorization type of financial insight.
 */
export enum InsightType {
  STRENGTH = 'STRENGTH',
  WEAKNESS = 'WEAKNESS',
  RECOMMENDATION = 'RECOMMENDATION',
  WARNING = 'WARNING',
  OPPORTUNITY = 'OPPORTUNITY',
}

/**
 * Financial risk level detection.
 */
export enum RiskLevel {
  LOW = 'LOW',
  MODERATE = 'MODERATE',
  HIGH = 'HIGH',
  SEVERE = 'SEVERE',
}

/**
 * Financial risk classification type.
 */
export enum RiskType {
  OVERSPENDING = 'OVERSPENDING',
  BUDGET_OVERRUN = 'BUDGET_OVERRUN',
  SAVINGS_DEFICIT = 'SAVINGS_DEFICIT',
  IRREGULAR_TRANSACTION = 'IRREGULAR_TRANSACTION',
  UNUSUAL_BEHAVIOR = 'UNUSUAL_BEHAVIOR',
}

/**
 * Review frequency for AI financial reviews.
 */
export enum ReviewFrequency {
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}
