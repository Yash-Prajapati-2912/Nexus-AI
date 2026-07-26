import { EntityManager } from 'typeorm';
import { BaseSeeder } from './seeder.base';
import { Logger } from '@nestjs/common';

/**
 * Testing Environment Seeder.
 * Seeds deterministic fixtures for automated integration and e2e testing.
 */
export class TestSeeder implements BaseSeeder {
  readonly name = 'TestSeeder';
  private readonly logger = new Logger(TestSeeder.name);

  async seed(_entityManager: EntityManager): Promise<void> {
    this.logger.log('[TestSeeder] Initializing test database fixtures...');
    // Foundation level test seeder ready for feature module integration testing
  }
}
