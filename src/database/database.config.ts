import { registerAs } from '@nestjs/config';
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import * as path from 'path';
import { DatabaseNamingStrategy } from './database.naming-strategy';
import { DatabaseLogger } from './database.logger';
import {
  DEFAULT_POOL_MAX_SIZE,
  DEFAULT_POOL_IDLE_TIMEOUT_MS,
  DEFAULT_POOL_CONNECT_TIMEOUT_MS,
  SLOW_QUERY_THRESHOLD_MS,
} from './database.constants';

/**
 * PostgreSQL & TypeORM Configuration Register.
 */
export const databaseConfig = registerAs('database', () => ({
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  username: process.env.DATABASE_USER || 'nexus_user',
  password: process.env.DATABASE_PASSWORD || 'nexus_password',
  database: process.env.DATABASE_NAME || 'nexus_db',
  schema: process.env.DATABASE_SCHEMA || 'public',
  ssl: process.env.DATABASE_SSL === 'true',
  sslRejectUnauthorized: process.env.DATABASE_SSL_REJECT_UNAUTHORIZED !== 'false',
  logging: process.env.DATABASE_LOGGING === 'true',
  poolSize: parseInt(process.env.DATABASE_POOL_SIZE || String(DEFAULT_POOL_MAX_SIZE), 10),
  idleTimeoutMillis: parseInt(
    process.env.DATABASE_IDLE_TIMEOUT || String(DEFAULT_POOL_IDLE_TIMEOUT_MS),
    10,
  ),
  connectionTimeoutMillis: parseInt(
    process.env.DATABASE_CONNECT_TIMEOUT || String(DEFAULT_POOL_CONNECT_TIMEOUT_MS),
    10,
  ),
  slowQueryThresholdMs: parseInt(
    process.env.DATABASE_SLOW_QUERY_THRESHOLD || String(SLOW_QUERY_THRESHOLD_MS),
    10,
  ),
  retryAttempts: parseInt(process.env.DATABASE_RETRY_ATTEMPTS || '10', 10),
  retryDelay: parseInt(process.env.DATABASE_RETRY_DELAY || '3000', 10),
  autoLoadEntities: true,
  migrationsRun: process.env.DATABASE_MIGRATIONS_RUN === 'true',
}));

/**
 * Factory function generating TypeORM connection options for NestJS TypeOrmModule.
 */
export function getDatabaseOptions(configService: ConfigService): TypeOrmModuleOptions {
  const isProduction = process.env.NODE_ENV === 'production';
  const sslEnabled = configService.get<boolean>('database.ssl') || false;
  const sslRejectUnauthorized =
    configService.get<boolean>('database.sslRejectUnauthorized') ?? true;

  const enableLogging = configService.get<boolean>('database.logging') ?? !isProduction;
  const slowQueryThreshold =
    configService.get<number>('database.slowQueryThresholdMs') || SLOW_QUERY_THRESHOLD_MS;

  return {
    type: 'postgres',
    host: configService.get<string>('database.host'),
    port: configService.get<number>('database.port'),
    username: configService.get<string>('database.username'),
    password: configService.get<string>('database.password'),
    database: configService.get<string>('database.database'),
    schema: configService.get<string>('database.schema') || 'public',

    // SSL Configuration
    ssl: sslEnabled
      ? {
          rejectUnauthorized: sslRejectUnauthorized,
        }
      : false,

    // MANDATORY: Never enable auto-synchronize in enterprise production/dev codebase
    synchronize: false,

    // Entity Auto-loading and explicit path fallbacks
    autoLoadEntities: true,
    entities: [path.join(__dirname, '../modules/**/*.entity{.ts,.js}')],

    // Migration directory configuration
    migrations: [path.join(__dirname, './migrations/*{.ts,.js}')],
    migrationsTableName: 'typeorm_migrations',
    migrationsRun: configService.get<boolean>('database.migrationsRun') || false,

    // Naming strategy enforcing snake_case standard
    namingStrategy: new DatabaseNamingStrategy(),

    // Structured logging
    logger: enableLogging ? new DatabaseLogger(slowQueryThreshold) : undefined,
    logging: enableLogging ? ['error', 'warn', 'migration', 'schema'] : false,

    // High performance connection pool settings (`pg-pool`)
    extra: {
      max: configService.get<number>('database.poolSize') || DEFAULT_POOL_MAX_SIZE,
      idleTimeoutMillis:
        configService.get<number>('database.idleTimeoutMillis') ||
        DEFAULT_POOL_IDLE_TIMEOUT_MS,
      connectionTimeoutMillis:
        configService.get<number>('database.connectionTimeoutMillis') ||
        DEFAULT_POOL_CONNECT_TIMEOUT_MS,
      statement_timeout: 30000, // 30s max query execution time safety guard
    },

    // Retry settings during boot connection initialization
    retryAttempts: configService.get<number>('database.retryAttempts') || 10,
    retryDelay: configService.get<number>('database.retryDelay') || 3000,
    keepConnectionAlive: true,
  };
}

export default databaseConfig;
