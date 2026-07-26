/**
 * Global Application Architecture Constants.
 * Centralized immutable configuration limits, headers, and pagination defaults.
 */
export const APP_CONSTANTS = {
  DEFAULT_PAGE: 1,
  DEFAULT_LIMIT: 20,
  MAX_LIMIT: 100,
  CORRELATION_ID_HEADER: 'x-correlation-id',
  IDEMPOTENCY_KEY_HEADER: 'idempotency-key',
  RESPONSE_TIME_HEADER: 'x-response-time-ms',
  DEPRECATION_HEADER: 'deprecation',
  SUNSET_HEADER: 'sunset',
};
