import { AppDataSource } from '../data-source';
import { DevSeeder } from './dev.seeder';
import { TestSeeder } from './test.seeder';
import { ProdSeeder } from './prod.seeder';
import { BaseSeeder } from './seeder.base';

/**
 * Standalone CLI Seeder Runner Script.
 * Usage: `npm run seed`, `npm run seed:dev`, `npm run seed:test`, `npm run seed:prod`
 */
async function runSeeds(): Promise<void> {
  const env = process.env.NODE_ENV || 'development';
  console.log(`[Seeder Runner] Initializing DataSource for environment: ${env}`);

  if (!AppDataSource.isInitialized) {
    await AppDataSource.initialize();
  }

  const queryRunner = AppDataSource.createQueryRunner();
  await queryRunner.connect();
  await queryRunner.startTransaction();

  try {
    const seeders: BaseSeeder[] = [];

    switch (env) {
      case 'production':
      case 'prod':
        seeders.push(new ProdSeeder());
        break;
      case 'test':
      case 'testing':
        seeders.push(new TestSeeder());
        break;
      case 'development':
      case 'dev':
      default:
        seeders.push(new DevSeeder());
        break;
    }

    for (const seeder of seeders) {
      console.log(`[Seeder Runner] Executing ${seeder.name}...`);
      await seeder.seed(queryRunner.manager);
      console.log(`[Seeder Runner] Successfully executed ${seeder.name}`);
    }

    await queryRunner.commitTransaction();
    console.log(`[Seeder Runner] All seeders completed successfully.`);
  } catch (error) {
    await queryRunner.rollbackTransaction();
    console.error(`[Seeder Runner Error] Seeding failed:`, error);
    process.exit(1);
  } finally {
    await queryRunner.release();
    if (AppDataSource.isInitialized) {
      await AppDataSource.destroy();
    }
  }
}

runSeeds();
