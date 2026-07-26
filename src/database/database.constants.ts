/**
 * Enterprise Database Injection Tokens and Architectural Constants.
 */

// NestJS Dependency Injection Tokens
export const DATA_SOURCE = Symbol('DATA_SOURCE');
export const DATABASE_CONNECTION = Symbol('DATABASE_CONNECTION');
export const TRANSACTION_SERVICE = Symbol('TRANSACTION_SERVICE');
export const DATABASE_HEALTH_SERVICE = Symbol('DATABASE_HEALTH_SERVICE');
export const DATABASE_LOGGER = Symbol('DATABASE_LOGGER');
export const DATABASE_NAMING_STRATEGY = Symbol('DATABASE_NAMING_STRATEGY');
export const DATABASE_OPTIONS = Symbol('DATABASE_OPTIONS');

// Performance & Latency Thresholds
export const SLOW_QUERY_THRESHOLD_MS = 500; // Queries exceeding 500ms trigger slow query warnings
export const DEFAULT_QUERY_TIMEOUT_MS = 10000; // Query execution timeout
export const DEFAULT_POOL_MAX_SIZE = 20; // Default pool size
export const DEFAULT_POOL_IDLE_TIMEOUT_MS = 30000; // 30s idle connection timeout
export const DEFAULT_POOL_CONNECT_TIMEOUT_MS = 5000; // 5s connection acquire timeout

// Database Retry & Transaction Settings
export const MAX_TRANSACTION_RETRIES = 3;
export const TRANSACTION_RETRY_DELAY_MS = 100;
export const DEFAULT_ISOLATION_LEVEL = 'READ COMMITTED';

// Health Check Constants
export const DATABASE_HEALTH_KEY = 'database';
export const HEALTH_CHECK_TIMEOUT_MS = 3000;

// Pagination Defaults
export const DEFAULT_PAGE_SIZE = 20;
export const MAX_PAGE_SIZE = 100;

// Database Error Codes (PostgreSQL Error Codes)
export enum PostgresErrorCode {
  UNIQUE_VIOLATION = '23505',
  FOREIGN_KEY_VIOLATION = '23503',
  NOT_NULL_VIOLATION = '23502',
  CHECK_VIOLATION = '23514',
  DEADLOCK_DETECTED = '40P01',
  SERIALIZATION_FAILURE = '40001',
  INSUFFICIENT_RESOURCES = '53000',
  TOO_MANY_CONNECTIONS = '53300',
}
