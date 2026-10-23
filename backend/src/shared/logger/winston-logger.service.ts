import { Injectable, LoggerService } from '@nestjs/common';
import * as winston from 'winston';
import { winstonLoggerOptions } from './winston.logger';

/**
 * Enterprise Shared Logger Service.
 * Implements NestJS `LoggerService` interface wrapping Winston structured JSON engine.
 * Supports domain log contexts: Application, Request, Performance, Error, Database, and AI.
 */
@Injectable()
export class EnterpriseLoggerService implements LoggerService {
  private readonly logger: winston.Logger;

  constructor() {
    this.logger = winston.createLogger(winstonLoggerOptions);
  }

  log(message: string, context?: string): void {
    this.logger.info(message, { context });
  }

  error(message: string, trace?: string, context?: string): void {
    this.logger.error(message, { trace, context });
  }

  warn(message: string, context?: string): void {
    this.logger.warn(message, { context });
  }

  debug(message: string, context?: string): void {
    this.logger.debug(message, { context });
  }

  verbose(message: string, context?: string): void {
    this.logger.verbose(message, { context });
  }

  logPerformance(operationName: string, durationMs: number, context?: string): void {
    this.logger.info(`PERFORMANCE: ${operationName} executed in ${durationMs}ms`, {
      type: 'PERFORMANCE',
      operationName,
      durationMs,
      context,
    });
  }

  logAiQuery(promptTokens: number, outputTokens: number, model: string, durationMs: number): void {
    this.logger.info(`AI_QUERY: ${model} processed [${promptTokens} in / ${outputTokens} out] in ${durationMs}ms`, {
      type: 'AI_QUERY',
      promptTokens,
      outputTokens,
      model,
      durationMs,
    });
  }
}
