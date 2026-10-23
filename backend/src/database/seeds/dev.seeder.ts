import { EntityManager } from 'typeorm';
import { BaseSeeder } from './seeder.base';
import { Logger } from '@nestjs/common';

/**
 * Development Environment Seeder.
 * Seeds initial mock data required during active development.
 */
export class DevSeeder implements BaseSeeder {
  readonly name = 'DevSeeder';
  private readonly logger = new Logger(DevSeeder.name);

  async seed(_entityManager: EntityManager): Promise<void> {
    this.logger.log('[DevSeeder] Initializing development database fixtures...');
    // Foundation level dev seeder ready for feature modules
  }
}
