import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { DatabaseNamingStrategy } from '../database.naming-strategy';

/**
 * Isolated Test Database Configuration.
 * Configures database parameters dedicated for automated integration and Jest test execution.
 */
export const testDatabaseConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  host: process.env.TEST_DATABASE_HOST || process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.TEST_DATABASE_PORT || process.env.DATABASE_PORT || '5432', 10),
  username: process.env.TEST_DATABASE_USER || process.env.DATABASE_USER || 'nexus_user',
  password: process.env.TEST_DATABASE_PASSWORD || process.env.DATABASE_PASSWORD || 'nexus_password',
  database: process.env.TEST_DATABASE_NAME || 'nexus_test_db',
  schema: 'public',
  synchronize: true, // Safe for isolated test database suites only
  logging: false,
  namingStrategy: new DatabaseNamingStrategy(),
  dropSchema: true, // Resets schema between test suit runs when enabled
  keepConnectionAlive: true,
};
