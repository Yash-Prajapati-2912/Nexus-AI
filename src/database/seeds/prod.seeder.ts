import { EntityManager } from 'typeorm';
import { BaseSeeder } from './seeder.base';
import { Logger } from '@nestjs/common';

/**
 * Production Environment Seeder.
 * Seeds essential baseline lookup data, system configuration constants, and roles.
 */
export class ProdSeeder implements BaseSeeder {
  readonly name = 'ProdSeeder';
  private readonly logger = new Logger(ProdSeeder.name);

  async seed(_entityManager: EntityManager): Promise<void> {
    this.logger.log('[ProdSeeder] Initializing production baseline seed data...');
    // Foundation level production seeder ready for feature system defaults
  }
}
