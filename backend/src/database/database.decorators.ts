import { DataSource } from 'typeorm';
import { ITransactionOptions } from './database.types';
import { TransactionHelper } from './database.transactions';

/**
 * Method Decorator `@Transactional()`.
 * Automatically wraps target service method within a PostgreSQL database transaction boundary.
 * Supports isolation levels, rollback handling, and nested SAVEPOINTs.
 *
 * Requirements:
 * Target instance must either inject `DataSource` or `TransactionService`, or access global DataSource context.
 */
export function Transactional(options: ITransactionOptions = {}): MethodDecorator {
  return function (
    _target: unknown,
    _propertyKey: string | symbol,
    descriptor: PropertyDescriptor,
  ) {
    const originalMethod = descriptor.value;

    descriptor.value = async function (...args: unknown[]) {
      // Find DataSource on host class instance
      let dataSource: DataSource | undefined;

      const keys = Object.keys(this || {});
      for (const key of keys) {
        const prop = (this as Record<string, unknown>)[key];
        if (prop && typeof prop === 'object' && 'createQueryRunner' in prop) {
          dataSource = prop as DataSource;
          break;
        } else if (
          prop &&
          typeof prop === 'object' &&
          'dataSource' in prop &&
          (prop as any).dataSource?.createQueryRunner
        ) {
          dataSource = (prop as any).dataSource as DataSource;
          break;
        }
      }

      if (!dataSource) {
        throw new Error(
          `@Transactional() decorator failed: Host instance of ${
            (_target as any)?.constructor?.name || 'Class'
          } must inject TypeORM 'DataSource' or 'TransactionService'.`,
        );
      }

      return TransactionHelper.runInTransaction(
        dataSource,
        async () => {
          return originalMethod.apply(this, args);
        },
        options,
      );
    };

    return descriptor;
  };
}
