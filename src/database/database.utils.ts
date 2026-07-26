import { PostgresErrorCode } from './database.constants';

/**
 * Enterprise Low-Level Database Utilities.
 */
export class DatabaseUtils {
  /**
   * Escapes SQL ILIKE / LIKE wildcard characters (`%`, `_`, `\`) to prevent injection.
   */
  static escapeLikeString(str: string): string {
    return str.replace(/[%_\\]/g, '\\$&');
  }

  /**
   * Checks if an error is a PostgreSQL Deadlock (40P01) or Serialization Failure (40001).
   */
  static isDeadlockError(error: unknown): boolean {
    const code = this.extractPostgresErrorCode(error);
    return (
      code === PostgresErrorCode.DEADLOCK_DETECTED ||
      code === PostgresErrorCode.SERIALIZATION_FAILURE
    );
  }

  /**
   * Checks if an error is a Unique Constraint Violation (23505).
   */
  static isUniqueViolationError(error: unknown): boolean {
    return this.extractPostgresErrorCode(error) === PostgresErrorCode.UNIQUE_VIOLATION;
  }

  /**
   * Checks if an error is a Foreign Key Constraint Violation (23503).
   */
  static isForeignKeyViolationError(error: unknown): boolean {
    return this.extractPostgresErrorCode(error) === PostgresErrorCode.FOREIGN_KEY_VIOLATION;
  }

  /**
   * Extracts PostgreSQL error code from raw error object.
   */
  static extractPostgresErrorCode(error: unknown): string | null {
    if (!error || typeof error !== 'object') return null;
    const errObj = error as { code?: string; driverError?: { code?: string } };
    return errObj.code || errObj.driverError?.code || null;
  }

  /**
   * Sanitizes table and column string identifiers to prevent SQL injection in dynamic DDL/raw queries.
   */
  static sanitizeIdentifier(identifier: string): string {
    return identifier.replace(/[^a-zA-Z0-9_.]/g, '');
  }

  /**
   * Measures async operation execution latency in milliseconds with high-resolution performance timer.
   */
  static async measureExecutionTimeMs<T>(
    operation: () => Promise<T>,
  ): Promise<{ result: T; durationMs: number }> {
    const start = performance.now();
    const result = await operation();
    const durationMs = Math.round(performance.now() - start);
    return { result, durationMs };
  }
}
