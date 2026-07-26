import { EntityManager, QueryRunner } from 'typeorm';

/**
 * Enterprise Database Type Definitions & Interfaces.
 */

export type SortOrder = 'ASC' | 'DESC';
export type NullsOrder = 'NULLS FIRST' | 'NULLS LAST';
export type Environment = 'development' | 'test' | 'production';

export type IsolationLevel =
  | 'READ UNCOMMITTED'
  | 'READ COMMITTED'
  | 'REPEATABLE READ'
  | 'SERIALIZABLE';

// Pagination Interfaces
export interface IPaginationOptions {
  page?: number;
  limit?: number;
}

export interface IPaginationMeta {
  page: number;
  limit: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface IPaginatedResult<T> {
  data: T[];
  meta: IPaginationMeta;
}

// Query Filtering & Sorting Contracts
export type FilterOperator =
  | 'eq'
  | 'neq'
  | 'gt'
  | 'gte'
  | 'lt'
  | 'lte'
  | 'in'
  | 'notIn'
  | 'like'
  | 'iLike'
  | 'isNull'
  | 'isNotNull'
  | 'between';

export interface IFilterCondition<T = unknown> {
  field: keyof T | string;
  operator: FilterOperator;
  value?: unknown;
}

export interface ISortCondition<T = unknown> {
  field: keyof T | string;
  order: SortOrder;
  nulls?: NullsOrder;
}

export interface IDateRangeFilter {
  field: string;
  startDate?: Date | string;
  endDate?: Date | string;
}

export interface ISearchFilter<T = unknown> {
  fields: (keyof T | string)[];
  query: string;
}

// Transaction Interfaces
export interface ITransactionOptions {
  isolationLevel?: IsolationLevel;
  retries?: number;
  retryDelayMs?: number;
  readOnly?: boolean;
}

export type TransactionCallback<T> = (
  entityManager: EntityManager,
  queryRunner?: QueryRunner,
) => Promise<T>;

// Database Logging Interfaces
export interface IQueryLogInfo {
  query: string;
  parameters?: unknown[];
  executionTimeMs?: number;
  timestamp: string;
}

export interface ISlowQueryLogInfo extends IQueryLogInfo {
  executionTimeMs: number;
  thresholdMs: number;
}

export interface IFailedQueryLogInfo extends IQueryLogInfo {
  error: Error | string;
  driverError?: unknown;
}

// Health & Performance Monitoring Contracts
export interface IPoolMetrics {
  totalCount: number;
  idleCount: number;
  waitingCount: number;
  activeCount: number;
  maxPoolSize: number;
}

export interface IDatabaseHealthStatus {
  status: 'up' | 'down';
  database: string;
  latencyMs: number;
  pool: IPoolMetrics;
  pendingMigrationsCount: number;
  isReady: boolean;
  isLive: boolean;
  timestamp: string;
  error?: string;
}

// Seeder Contracts
export interface ISeederOptions {
  environment: Environment;
  verbose?: boolean;
}

export interface ISeeder {
  name: string;
  run(entityManager: EntityManager): Promise<void>;
}

// Factory Type
export type EntityFactory<T> = (overrides?: Partial<T>) => Partial<T>;
