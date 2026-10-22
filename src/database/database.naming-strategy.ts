import { DefaultNamingStrategy, NamingStrategyInterface } from 'typeorm';

/**
 * Pure snake_case string formatter utility.
 */
function snakeCase(str: string): string {
  return str
    .replace(/([a-z0-9])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .replace(/[\s-]+/g, '_')
    .toLowerCase();
}

/**
 * Enterprise PostgreSQL Snake Case Naming Strategy.
 * Standardizes identifier naming conventions across PostgreSQL tables, columns,
 * foreign keys, primary keys, unique constraints, and indexes.
 *
 * Rules:
 * - Tables: snake_case (singular / domain module entity name)
 * - Columns: snake_case (`created_at`, `updated_at`, `deleted_at`, `created_by`, `updated_by`)
 * - Primary Key: `pk_${tableName}`
 * - Foreign Keys: `fk_${tableName}_${referencedTable}_${columnNames}`
 * - Unique Constraints: `uq_${tableName}_${columnNames}`
 * - Index Constraints: `idx_${tableName}_${columnNames}`
 * - Check Constraints: `chk_${tableName}_${columnNames}`
 */
export class DatabaseNamingStrategy
  extends DefaultNamingStrategy
  implements NamingStrategyInterface
{
  tableName(className: string, customName: string | undefined): string {
    return customName ? customName : snakeCase(className);
  }

  columnName(
    propertyName: string,
    customName: string | undefined,
    embeddedPrefixes: string[],
  ): string {
    return (
      snakeCase(embeddedPrefixes.concat('').join('_')) +
      (customName ? customName : snakeCase(propertyName))
    );
  }

  relationName(propertyName: string): string {
    return snakeCase(propertyName);
  }

  joinColumnName(relationProperty: string, referencedColumnName: string): string {
    return snakeCase(`${relationProperty}_${referencedColumnName}`);
  }

  joinTableName(
    firstTableName: string,
    secondTableName: string,
    firstPropertyName: string,
  ): string {
    return snakeCase(
      `${firstTableName}_${secondTableName}_${firstPropertyName.replace(/\./g, '_')}`,
    );
  }

  joinTableColumnName(
    tableName: string,
    propertyName: string,
    columnName?: string,
  ): string {
    return snakeCase(`${tableName}_${columnName || propertyName}`);
  }

  classTableInheritanceParentColumnName(
    parentTableName: string,
    parentTableIdPropertyName: string,
  ): string {
    return snakeCase(`${parentTableName}_${parentTableIdPropertyName}`);
  }

  protected getTableName(tableOrName: any): string {
    if (typeof tableOrName === 'string') {
      return tableOrName.split('.').pop() || tableOrName;
    }
    if (tableOrName && typeof tableOrName.name === 'string') {
      return tableOrName.name.split('.').pop() || tableOrName.name;
    }
    return 'table';
  }

  primaryKeyName(tableOrName: any, columnNames: string[]): string {
    const table = this.getTableName(tableOrName);
    const cols = columnNames.map((c) => snakeCase(c)).join('_');
    return `pk_${table}${cols ? `_${cols}` : ''}`;
  }

  uniqueConstraintName(tableOrName: any, columnNames: string[]): string {
    const table = this.getTableName(tableOrName);
    const cols = columnNames.map((c) => snakeCase(c)).join('_');
    return `uq_${table}_${cols}`;
  }

  relationConstraintName(tableOrName: any, columnNames: string[]): string {
    const table = this.getTableName(tableOrName);
    const cols = columnNames.map((c) => snakeCase(c)).join('_');
    return `fk_${table}_${cols}`;
  }

  foreignKeyName(
    tableOrName: any,
    columnNames: string[],
    referencedTablePath?: string,
    _referencedColumnNames?: string[],
  ): string {
    const table = this.getTableName(tableOrName);
    const refTable = referencedTablePath ? referencedTablePath.replace('.', '_') : 'ref';
    const cols = columnNames.map((c) => snakeCase(c)).join('_');
    return `fk_${table}_${refTable}_${cols}`;
  }

  indexName(tableOrName: any, columnNames: string[], where?: string): string {
    const table = this.getTableName(tableOrName);
    const cols = columnNames.map((c) => snakeCase(c)).join('_');
    const suffix = where ? '_partial' : '';
    return `idx_${table}_${cols}${suffix}`;
  }

  checkConstraintName(tableOrName: any, expression: string): string {
    const table = this.getTableName(tableOrName);
    const cleanExpr = expression.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase();
    const truncatedExpr = cleanExpr.length > 20 ? cleanExpr.substring(0, 20) : cleanExpr;
    return `chk_${table}_${truncatedExpr}`;
  }
}
