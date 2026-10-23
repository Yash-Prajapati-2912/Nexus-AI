import { DeepPartial, Repository } from 'typeorm';
import { BaseEntity } from '../base.entity';
import { EntityFactory } from '../database.types';

/**
 * Enterprise Database Entity Factory Helper.
 * Enables fluent mock data generation and database persistence for automated test suites.
 */
export class DatabaseFactoryHelper<T extends BaseEntity> {
  constructor(
    private readonly repository: Repository<T>,
    private readonly defaultFactory: EntityFactory<T>,
  ) {}

  /**
   * Generates unpersisted entity instance with partial overrides.
   */
  make(overrides: Partial<T> = {}): T {
    const defaultData = this.defaultFactory(overrides);
    const merged = { ...defaultData, ...overrides };
    return this.repository.create(merged as DeepPartial<T>);
  }

  /**
   * Generates and persists entity instance directly into test database.
   */
  async create(overrides: Partial<T> = {}): Promise<T> {
    const entity = this.make(overrides);
    return this.repository.save(entity as DeepPartial<T>);
  }

  /**
   * Generates and persists multiple entity instances in batch.
   */
  async createMany(count: number, overrides: Partial<T> = {}): Promise<T[]> {
    const entities: T[] = [];
    for (let i = 0; i < count; i++) {
      entities.push(this.make(overrides));
    }
    return this.repository.save(entities as DeepPartial<T>[]);
  }
}
