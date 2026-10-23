import { EntityManager } from 'typeorm';

/**
 * Testing Seeders Manager.
 * Facilitates custom fixture population during unit/integration tests.
 */
export class TestingSeeders {
  /**
   * Cleans all non-system tables in the public schema for test isolation.
   */
  static async truncateAllTables(entityManager: EntityManager): Promise<void> {
    const tables: Array<{ tablename: string }> = await entityManager.query(
      `SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename != 'typeorm_migrations'`,
    );

    if (tables.length > 0) {
      const tableNames = tables.map((t) => `"${t.tablename}"`).join(', ');
      await entityManager.query(`TRUNCATE TABLE ${tableNames} CASCADE`);
    }
  }
}
