import { Injectable, Logger } from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';
import { Environment, ISeederOptions } from './database.types';

/**
 * Interface contract for domain seeders.
 */
export interface ISeederRunner {
  name: string;
  run(entityManager: EntityManager): Promise<void>;
}

/**
 * Master Seeder Orchestrator.
 * Executes environment-specific database seeders within an isolated database transaction.
 */
@Injectable()
export class DatabaseSeederService {
  private readonly logger = new Logger(DatabaseSeederService.name);
  private readonly seeders: Map<Environment, ISeederRunner[]> = new Map();

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Registers a seeder for a specific environment.
   */
  registerSeeder(environment: Environment, seeder: ISeederRunner): void {
    const list = this.seeders.get(environment) || [];
    list.push(seeder);
    this.seeders.set(environment, list);
  }

  /**
   * Executes seeders registered for the current active environment.
   */
  async runSeeders(options?: ISeederOptions): Promise<void> {
    const env = (options?.environment || process.env.NODE_ENV || 'development') as Environment;
    this.logger.log(`[Database Seeder] Starting database seeding for environment: ${env}`);

    const registeredSeeders = this.seeders.get(env) || [];

    if (registeredSeeders.length === 0) {
      this.logger.warn(`[Database Seeder] No seeders registered for environment '${env}'. Skipping.`);
      return;
    }

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      for (const seeder of registeredSeeders) {
        this.logger.log(`[Database Seeder] Executing seeder: ${seeder.name}`);
        const start = performance.now();
        await seeder.run(queryRunner.manager);
        const duration = Math.round(performance.now() - start);
        this.logger.log(`[Database Seeder] Successfully executed ${seeder.name} (${duration}ms)`);
      }

      await queryRunner.commitTransaction();
      this.logger.log(`[Database Seeder] All seeders completed successfully for environment '${env}'.`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `[Database Seeder Error] Seeding failed: ${error instanceof Error ? error.message : String(error)}`,
        error instanceof Error ? error.stack : undefined,
      );
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
