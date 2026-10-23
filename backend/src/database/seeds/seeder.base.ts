import { EntityManager } from 'typeorm';

/**
 * Base Interface Contract for Database Seeders.
 */
export interface BaseSeeder {
  readonly name: string;
  seed(entityManager: EntityManager): Promise<void>;
}
