import { Injectable, Logger } from '@nestjs/common';
import { DataSource, EntityManager, QueryRunner } from 'typeorm';
import { AsyncLocalStorage } from 'async_hooks';
import { ITransactionOptions, TransactionCallback } from './database.types';
import { DatabaseUtils } from './database.utils';
import {
  MAX_TRANSACTION_RETRIES,
  TRANSACTION_RETRY_DELAY_MS,
  DEFAULT_ISOLATION_LEVEL,
} from './database.constants';

/**
 * Global AsyncLocalStorage store holding current transactional EntityManager context.
 * Enables automatic nested context propagation without passing EntityManager explicitly down deep call stacks.
 */
export const transactionStorage = new AsyncLocalStorage<EntityManager>();

/**
 * Enterprise Transaction Helper.
 * Manages raw QueryRunner lifecycle, commit/rollback, and savepoints for nested transactions.
 */
export class TransactionHelper {
  /**
   * Generates a unique savepoint identifier for nested transactions.
   */
  static generateSavepointName(): string {
    return `sp_${Date.now()}_${Math.floor(Math.random() * 10000)}`;
  }

  /**
   * Executes work within a transaction or nested savepoint.
   */
  static async runInTransaction<T>(
    dataSource: DataSource,
    work: TransactionCallback<T>,
    options: ITransactionOptions = {},
  ): Promise<T> {
    const existingEntityManager = transactionStorage.getStore();

    // If already in a transaction context, create a SAVEPOINT for nested transaction support
    if (existingEntityManager) {
      const savepointName = this.generateSavepointName();
      const queryRunner = existingEntityManager.queryRunner;

      if (queryRunner && !queryRunner.isReleased) {
        await queryRunner.query(`SAVEPOINT ${savepointName}`);
        try {
          const result = await work(existingEntityManager, queryRunner);
          await queryRunner.query(`RELEASE SAVEPOINT ${savepointName}`);
          return result;
        } catch (error) {
          await queryRunner.query(`ROLLBACK TO SAVEPOINT ${savepointName}`);
          throw error;
        }
      } else {
        // Fallback to active entity manager if query runner is detached
        return work(existingEntityManager);
      }
    }

    // New outer transaction boundary
    const queryRunner: QueryRunner = dataSource.createQueryRunner();
    await queryRunner.connect();

    const isolationLevel = options.isolationLevel || DEFAULT_ISOLATION_LEVEL;
    await queryRunner.startTransaction(isolationLevel as any);

    try {
      // Execute work inside AsyncLocalStorage context
      const result = await transactionStorage.run(queryRunner.manager, async () => {
        return work(queryRunner.manager, queryRunner);
      });

      await queryRunner.commitTransaction();
      return result;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}

/**
 * Enterprise Transaction Service.
 * Injected NestJS provider facilitating isolated database operations with automatic transient error retries (deadlocks).
 */
@Injectable()
export class TransactionService {
  private readonly logger = new Logger(TransactionService.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Retrieves current transactional EntityManager from AsyncLocalStorage if inside a active `@Transactional` context.
   */
  get currentEntityManager(): EntityManager | undefined {
    return transactionStorage.getStore();
  }

  /**
   * Executes transactional block with retry logic for transient PostgreSQL deadlock errors.
   */
  async execute<T>(
    work: TransactionCallback<T>,
    options: ITransactionOptions = {},
  ): Promise<T> {
    const maxRetries = options.retries ?? MAX_TRANSACTION_RETRIES;
    const retryDelay = options.retryDelayMs ?? TRANSACTION_RETRY_DELAY_MS;
    let attempt = 0;

    while (true) {
      try {
        return await TransactionHelper.runInTransaction(this.dataSource, work, options);
      } catch (error) {
        attempt++;

        // Retry if error is PostgreSQL deadlock or serialization failure and maxRetries not reached
        if (DatabaseUtils.isDeadlockError(error) && attempt <= maxRetries) {
          this.logger.warn(
            `[Deadlock Detected] Transaction attempt ${attempt}/${maxRetries} failed. Retrying in ${retryDelay}ms...`,
          );
          await new Promise((resolve) => setTimeout(resolve, retryDelay * attempt));
          continue;
        }

        throw error;
      }
    }
  }
}
