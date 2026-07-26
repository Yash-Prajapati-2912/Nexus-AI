import {
  Repository,
  FindOptionsWhere,
  FindOneOptions,
  FindManyOptions,
  DeepPartial,
  QueryRunner,
  EntityManager,
  SelectQueryBuilder,
} from 'typeorm';
import { QueryDeepPartialEntity } from 'typeorm/query-builder/QueryPartialEntity';
import { BaseEntity } from './base.entity';
import {
  IPaginatedResult,
  IPaginationOptions,
  IFilterCondition,
  ISortCondition,
  ISearchFilter,
  IDateRangeFilter,
} from './database.types';
import { QueryBuilderHelper } from './database.helpers';
import { DEFAULT_PAGE_SIZE } from './database.constants';

/**
 * Enterprise Abstract Base Repository.
 * Encapsulates TypeORM `Repository<T>` to provide uniform CRUD, paginated querying,
 * dynamic search/filtering, soft deletion, restoration, and seamless transaction execution.
 */
export abstract class BaseRepository<T extends BaseEntity> {
  constructor(protected readonly repository: Repository<T>) {}

  /**
   * Helper to retrieve target repository or transactional entity manager repository.
   */
  protected getRepo(entityManager?: EntityManager): Repository<T> {
    if (entityManager) {
      return entityManager.getRepository<T>(this.repository.target);
    }
    return this.repository;
  }

  /**
   * Creates a SelectQueryBuilder for advanced custom querying.
   */
  createQueryBuilder(alias?: string, queryRunner?: QueryRunner): SelectQueryBuilder<T> {
    const targetAlias = alias || this.repository.metadata.tableName;
    return this.repository.createQueryBuilder(targetAlias, queryRunner);
  }

  /**
   * Find single record matching conditions.
   */
  async findOne(
    options: FindOneOptions<T>,
    entityManager?: EntityManager,
  ): Promise<T | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne(options);
  }

  /**
   * Find single record by primary key UUID.
   */
  async findById(
    id: string,
    relations: string[] = [],
    entityManager?: EntityManager,
  ): Promise<T | null> {
    const repo = this.getRepo(entityManager);
    const findOptions: FindOneOptions<T> = {
      where: { id } as unknown as FindOptionsWhere<T>,
    };

    if (relations.length > 0) {
      findOptions.relations = relations;
    }

    return repo.findOne(findOptions);
  }

  /**
   * Find array of records matching conditions.
   */
  async findMany(
    options?: FindManyOptions<T>,
    entityManager?: EntityManager,
  ): Promise<T[]> {
    const repo = this.getRepo(entityManager);
    return repo.find(options);
  }

  /**
   * Standardized Paginated Query Builder.
   * Integrates pagination, multi-field ILIKE searching, dynamic column filtering,
   * date range bounds, multi-column sorting, and soft deletion scoping.
   */
  async findAllPaginated(
    options: IPaginationOptions = {},
    filters: IFilterCondition<T>[] = [],
    sort: ISortCondition<T>[] = [],
    search?: ISearchFilter<T>,
    dateRange?: IDateRangeFilter,
    includeDeleted: boolean = false,
    entityManager?: EntityManager,
  ): Promise<IPaginatedResult<T>> {
    const alias = this.repository.metadata.tableName;
    const qb = this.getRepo(entityManager).createQueryBuilder(alias);

    // Apply Soft Delete Filter
    QueryBuilderHelper.applySoftDelete(qb, includeDeleted, alias);

    // Apply Search
    if (search && search.query && search.fields.length > 0) {
      QueryBuilderHelper.applySearch(qb, search.fields as string[], search.query, alias);
    }

    // Apply Dynamic Filters
    if (filters.length > 0) {
      QueryBuilderHelper.applyFilters(qb, filters, alias);
    }

    // Apply Date Range
    if (dateRange && (dateRange.startDate || dateRange.endDate)) {
      QueryBuilderHelper.applyDateRange(
        qb,
        dateRange.field,
        dateRange.startDate,
        dateRange.endDate,
        alias,
      );
    }

    // Apply Sorting
    QueryBuilderHelper.applySorting(qb, sort, [{ field: 'createdAt', order: 'DESC' }], alias);

    // Apply Pagination
    const page = Math.max(1, options.page || 1);
    const limit = Math.max(1, options.limit || DEFAULT_PAGE_SIZE);
    QueryBuilderHelper.applyPagination(qb, page, limit);

    const [data, totalItems] = await qb.getManyAndCount();

    const totalPages = Math.ceil(totalItems / limit) || 1;

    return {
      data,
      meta: {
        page,
        limit,
        totalItems,
        totalPages,
        hasNextPage: page < totalPages,
        hasPreviousPage: page > 1,
      },
    };
  }

  /**
   * Check if at least one matching record exists.
   */
  async exists(
    where: FindOptionsWhere<T> | FindOptionsWhere<T>[],
    entityManager?: EntityManager,
  ): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const count = await repo.count({ where });
    return count > 0;
  }

  /**
   * Count total records matching criteria.
   */
  async count(
    where?: FindOptionsWhere<T> | FindOptionsWhere<T>[],
    entityManager?: EntityManager,
  ): Promise<number> {
    const repo = this.getRepo(entityManager);
    return repo.count({ where });
  }

  /**
   * Instantiate unpersisted entity instance with audit tracking.
   */
  create(entityLike: DeepPartial<T>, userId?: string): T {
    const entity = this.repository.create(entityLike);
    if (userId) {
      entity.setAuditUser(userId);
    }
    return entity;
  }

  /**
   * Persist single entity into database.
   */
  async save(
    entity: DeepPartial<T>,
    userId?: string,
    entityManager?: EntityManager,
  ): Promise<T> {
    const repo = this.getRepo(entityManager);
    const entityInstance = repo.create(entity);
    if (userId) {
      entityInstance.setAuditUser(userId);
    }
    return repo.save(entityInstance);
  }

  /**
   * Persist multiple entities in batch.
   */
  async saveMany(
    entities: DeepPartial<T>[],
    userId?: string,
    entityManager?: EntityManager,
  ): Promise<T[]> {
    const repo = this.getRepo(entityManager);
    const instances = entities.map((item) => {
      const inst = repo.create(item);
      if (userId) {
        inst.setAuditUser(userId);
      }
      return inst;
    });
    return repo.save(instances);
  }

  /**
   * Update entity by ID with partial property updates.
   */
  async update(
    id: string,
    partialEntity: QueryDeepPartialEntity<T>,
    userId?: string,
    entityManager?: EntityManager,
  ): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const updatePayload = { ...partialEntity } as Record<string, unknown>;
    if (userId) {
      updatePayload.updatedBy = userId;
    }
    const result = await repo.update(
      id,
      updatePayload as QueryDeepPartialEntity<T>,
    );
    return (result.affected || 0) > 0;
  }

  /**
   * Soft Delete entity by ID (sets deleted_at timestamp).
   */
  async softDeleteById(
    id: string,
    userId?: string,
    entityManager?: EntityManager,
  ): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    if (userId) {
      await repo.update(id, { updatedBy: userId } as unknown as QueryDeepPartialEntity<T>);
    }
    const result = await repo.softDelete(id);
    return (result.affected || 0) > 0;
  }

  /**
   * Restore soft-deleted entity by ID.
   */
  async restore(id: string, entityManager?: EntityManager): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const result = await repo.restore(id);
    return (result.affected || 0) > 0;
  }

  /**
   * Hard Delete (permanent deletion) entity from database by ID.
   */
  async hardDelete(id: string, entityManager?: EntityManager): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const result = await repo.delete(id);
    return (result.affected || 0) > 0;
  }
}
