/**
 * Theme mode options.
 */
export enum ThemeMode {
  LIGHT = 'LIGHT',
  DARK = 'DARK',
  SYSTEM = 'SYSTEM',
}

/**
 * Start day of week options.
 */
export enum StartOfWeek {
  SUNDAY = 'SUNDAY',
  MONDAY = 'MONDAY',
  SATURDAY = 'SATURDAY',
}

/**
 * AI Response style choices.
 */
export enum AIResponseStyle {
  CONCISE = 'CONCISE',
  BALANCED = 'BALANCED',
  DETAILED = 'DETAILED',
  ACADEMIC = 'ACADEMIC',
}

/**
 * AI Creativity level options.
 */
export enum AICreativityLevel {
  PRECISE = 'PRECISE',
  BALANCED = 'BALANCED',
  CREATIVE = 'CREATIVE',
}

/**
 * Audit log action types.
 */
export enum AuditActionType {
  SETTINGS_UPDATE = 'SETTINGS_UPDATE',
  SECURITY_UPDATE = 'SECURITY_UPDATE',
  PREFERENCE_UPDATE = 'PREFERENCE_UPDATE',
  FEATURE_FLAG_UPDATE = 'FEATURE_FLAG_UPDATE',
  ADMIN_ACTION = 'ADMIN_ACTION',
  LOGIN = 'LOGIN',
  PASSWORD_CHANGE = 'PASSWORD_CHANGE',
}

/**
 * Feature flag scopes.
 */
export enum FeatureFlagScope {
  GLOBAL = 'GLOBAL',
  USER = 'USER',
  PERCENTAGE = 'PERCENTAGE',
  ENVIRONMENT = 'ENVIRONMENT',
}
