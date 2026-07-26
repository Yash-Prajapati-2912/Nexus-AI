import { DataSource, QueryRunner } from 'typeorm';

/**
 * Test Transaction Auto-Rollback Helper.
 * Wraps integration test cases inside a transaction that is guaranteed to ROLLBACK upon completion,
 * ensuring test database state remains 100% pristine without persistent side effects.
 */
export class TransactionRollbackHelper {
  private queryRunner: QueryRunner | null = null;

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Begins isolated transaction before test execution.
   */
  async startTestTransaction(): Promise<QueryRunner> {
    this.queryRunner = this.dataSource.createQueryRunner();
    await this.queryRunner.connect();
    await this.queryRunner.startTransaction();
    return this.queryRunner;
  }

  /**
   * Rollbacks transaction and releases query runner after test completion.
   */
  async rollbackTestTransaction(): Promise<void> {
    if (this.queryRunner) {
      if (this.queryRunner.isTransactionActive) {
        await this.queryRunner.rollbackTransaction();
      }
      await this.queryRunner.release();
      this.queryRunner = null;
    }
  }

  /**
   * Executes a given test block inside an auto-rolling-back transaction.
   */
  static async runInRollbackTransaction<T>(
    dataSource: DataSource,
    testBlock: (queryRunner: QueryRunner) => Promise<T>,
  ): Promise<T> {
    const helper = new TransactionRollbackHelper(dataSource);
    const queryRunner = await helper.startTestTransaction();
    try {
      return await testBlock(queryRunner);
    } finally {
      await helper.rollbackTestTransaction();
    }
  }
}
