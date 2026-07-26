import { registerAs } from '@nestjs/config';

/**
 * PostgreSQL & TypeORM Database Configuration Namespace.
 * Provides type-safe database connection parameters, SSL settings, and connection pool sizing.
 */
export default registerAs('database', () => ({
  host: process.env.DATABASE_HOST || 'postgres',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  username: process.env.DATABASE_USER || 'nexus_user',
  password: process.env.DATABASE_PASSWORD || 'nexus_password',
  database: process.env.DATABASE_NAME || 'nexus_db',
  schema: process.env.DATABASE_SCHEMA || 'public',
  ssl: process.env.DATABASE_SSL === 'true',
  logging: process.env.DATABASE_LOGGING === 'true',
  poolSize: parseInt(process.env.DATABASE_POOL_SIZE || '20', 10),
}));
