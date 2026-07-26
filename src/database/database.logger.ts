import { Logger as TypeOrmLogger, QueryRunner } from 'typeorm';
import { Logger } from '@nestjs/common';
import { SLOW_QUERY_THRESHOLD_MS } from './database.constants';

/**
 * Enterprise Structured Database Logger.
 * Captures query latency, warns on slow execution times exceeding threshold,
 * logs PostgreSQL errors with full query parameter context, and tracks migration lifecycle events.
 */
export class DatabaseLogger implements TypeOrmLogger {
  private readonly logger = new Logger('DatabaseService');

  constructor(private readonly slowQueryThresholdMs: number = SLOW_QUERY_THRESHOLD_MS) {}

  /**
   * Logs standard SQL queries (enabled when logging: true or log levels include 'query').
   */
  logQuery(query: string, parameters?: unknown[], _queryRunner?: QueryRunner): void {
    this.logger.debug(
      `[SQL Query] ${query} ${parameters && parameters.length ? `| Params: ${JSON.stringify(parameters)}` : ''}`,
    );
  }

  /**
   * Logs failed SQL queries with PostgreSQL error messages and parameter context.
   */
  logQueryError(
    error: string | Error,
    query: string,
    parameters?: unknown[],
    _queryRunner?: QueryRunner,
  ): void {
    const errorMessage = error instanceof Error ? error.message : error;
    const stack = error instanceof Error ? error.stack : undefined;

    this.logger.error(
      `[SQL Error] Execution Failed: ${errorMessage}\n` +
        `Query: ${query}\n` +
        `Parameters: ${JSON.stringify(parameters || [])}`,
      stack,
    );
  }

  /**
   * Logs queries that exceed the slow query threshold.
   */
  logQuerySlow(
    time: number,
    query: string,
    parameters?: unknown[],
    _queryRunner?: QueryRunner,
  ): void {
    this.logger.warn(
      `[SLOW QUERY] Latency: ${time}ms (Threshold: ${this.slowQueryThresholdMs}ms)\n` +
        `Query: ${query}\n` +
        `Parameters: ${JSON.stringify(parameters || [])}`,
    );
  }

  /**
   * Logs DDL schema build execution.
   */
  logSchemaBuild(message: string, _queryRunner?: QueryRunner): void {
    this.logger.log(`[Schema Build] ${message}`);
  }

  /**
   * Logs migration execution events.
   */
  logMigration(message: string, _queryRunner?: QueryRunner): void {
    this.logger.log(`[Database Migration] ${message}`);
  }

  /**
   * Logs general database information messages.
   */
  log(level: 'log' | 'info' | 'warn', message: unknown, _queryRunner?: QueryRunner): void {
    const formattedMessage = typeof message === 'string' ? message : JSON.stringify(message);

    switch (level) {
      case 'warn':
        this.logger.warn(`[Database Warning] ${formattedMessage}`);
        break;
      case 'info':
      case 'log':
      default:
        this.logger.log(`[Database Info] ${formattedMessage}`);
        break;
    }
  }
}
