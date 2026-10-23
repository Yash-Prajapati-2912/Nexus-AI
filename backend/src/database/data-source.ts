import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as path from 'path';

// Load environment variables for TypeORM CLI operations
const envFile = process.env.NODE_ENV ? `.env.${process.env.NODE_ENV}` : '.env.development';
dotenv.config({ path: path.resolve(process.cwd(), envFile) });

/**
 * Standalone TypeORM DataSource Configuration Instance.
 * Dedicated for TypeORM CLI operations (migration generation, execution, and reversion).
 * Strictly enforces `synchronize: false` and `logging: true`.
 */
export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  username: process.env.DATABASE_USER || 'nexus_user',
  password: process.env.DATABASE_PASSWORD || 'nexus_password',
  database: process.env.DATABASE_NAME || 'nexus_db',
  schema: process.env.DATABASE_SCHEMA || 'public',
  ssl: process.env.DATABASE_SSL === 'true',
  synchronize: false, // MANDATORY: Disable auto-sync to prevent production column drops
  logging: process.env.DATABASE_LOGGING === 'true',
  entities: [path.join(__dirname, '../modules/**/*.entity{.ts,.js}')],
  migrations: [path.join(__dirname, './migrations/*{.ts,.js}')],
  subscribers: [],
});
