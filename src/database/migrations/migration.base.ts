import { MigrationInterface, QueryRunner, Table, TableIndex, TableForeignKey } from 'typeorm';

/**
 * Abstract Base Class for TypeORM Schema Migrations.
 * Provides safe helper methods for creating tables, indexes, foreign keys, and DDL execution.
 */
export abstract class BaseMigration implements MigrationInterface {
  abstract name?: string;

  abstract up(queryRunner: QueryRunner): Promise<void>;
  abstract down(queryRunner: QueryRunner): Promise<void>;

  /**
   * Helper to execute safe table creation with check if not exists.
   */
  protected async createTableIfNotExists(
    queryRunner: QueryRunner,
    table: Table,
  ): Promise<void> {
    const exists = await queryRunner.hasTable(table.name);
    if (!exists) {
      await queryRunner.createTable(table, true);
    }
  }

  /**
   * Helper to drop table if it exists.
   */
  protected async dropTableIfExists(
    queryRunner: QueryRunner,
    tableName: string,
  ): Promise<void> {
    const exists = await queryRunner.hasTable(tableName);
    if (exists) {
      await queryRunner.dropTable(tableName, true, true, true);
    }
  }

  /**
   * Helper to create index if it doesn't already exist.
   */
  protected async createIndexIfNotExists(
    queryRunner: QueryRunner,
    tableName: string,
    index: TableIndex,
  ): Promise<void> {
    const table = await queryRunner.getTable(tableName);
    if (table) {
      const indexExists = table.indices.some((idx) => idx.name === index.name);
      if (!indexExists) {
        await queryRunner.createIndex(tableName, index);
      }
    }
  }

  /**
   * Helper to create foreign key constraint safely.
   */
  protected async createForeignKeyIfNotExists(
    queryRunner: QueryRunner,
    tableName: string,
    foreignKey: TableForeignKey,
  ): Promise<void> {
    const table = await queryRunner.getTable(tableName);
    if (table) {
      const fkExists = table.foreignKeys.some((fk) => fk.name === foreignKey.name);
      if (!fkExists) {
        await queryRunner.createForeignKey(tableName, foreignKey);
      }
    }
  }
}
