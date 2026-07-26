import { SelectQueryBuilder, ObjectLiteral } from 'typeorm';
import { IFilterCondition, ISortCondition } from './database.types';
import { DatabaseUtils } from './database.utils';
import { DEFAULT_PAGE_SIZE, MAX_PAGE_SIZE } from './database.constants';

/**
 * Enterprise Query Builder Helper.
 * Supplies chainable helper methods for dynamic TypeORM `SelectQueryBuilder` query construction.
 */
export class QueryBuilderHelper {
  /**
   * Applies limit and offset pagination.
   */
  static applyPagination<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    page?: number,
    limit?: number,
  ): SelectQueryBuilder<T> {
    const validPage = Math.max(1, page || 1);
    const validLimit = Math.min(MAX_PAGE_SIZE, Math.max(1, limit || DEFAULT_PAGE_SIZE));
    const skip = (validPage - 1) * validLimit;

    return qb.skip(skip).take(validLimit);
  }

  /**
   * Applies multi-column sorting.
   */
  static applySorting<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    sortConditions: ISortCondition<T>[] = [],
    defaultSort: ISortCondition<T>[] = [{ field: 'createdAt', order: 'DESC' }],
    alias?: string,
  ): SelectQueryBuilder<T> {
    const targetAlias = alias || qb.alias;
    const conditionsToApply =
      sortConditions && sortConditions.length > 0 ? sortConditions : defaultSort;

    conditionsToApply.forEach((sort, index) => {
      const sanitizedField = DatabaseUtils.sanitizeIdentifier(sort.field as string);
      const column = sanitizedField.includes('.')
        ? sanitizedField
        : `${targetAlias}.${sanitizedField}`;

      if (index === 0) {
        qb.orderBy(column, sort.order, sort.nulls);
      } else {
        qb.addOrderBy(column, sort.order, sort.nulls);
      }
    });

    return qb;
  }

  /**
   * Applies dynamic column filtering based on operators (`eq`, `neq`, `gt`, `gte`, `lt`, `lte`, `in`, `notIn`, `like`, `iLike`, `isNull`, `isNotNull`, `between`).
   */
  static applyFilters<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    filters: IFilterCondition<T>[] = [],
    alias?: string,
  ): SelectQueryBuilder<T> {
    const targetAlias = alias || qb.alias;

    filters.forEach((filter, index) => {
      if (!filter.field) return;

      const sanitizedField = DatabaseUtils.sanitizeIdentifier(filter.field as string);
      const column = sanitizedField.includes('.')
        ? sanitizedField
        : `${targetAlias}.${sanitizedField}`;
      const paramName = `filter_${sanitizedField.replace(/\./g, '_')}_${index}`;

      switch (filter.operator) {
        case 'eq':
          qb.andWhere(`${column} = :${paramName}`, { [paramName]: filter.value });
          break;
        case 'neq':
          qb.andWhere(`${column} != :${paramName}`, { [paramName]: filter.value });
          break;
        case 'gt':
          qb.andWhere(`${column} > :${paramName}`, { [paramName]: filter.value });
          break;
        case 'gte':
          qb.andWhere(`${column} >= :${paramName}`, { [paramName]: filter.value });
          break;
        case 'lt':
          qb.andWhere(`${column} < :${paramName}`, { [paramName]: filter.value });
          break;
        case 'lte':
          qb.andWhere(`${column} <= :${paramName}`, { [paramName]: filter.value });
          break;
        case 'in':
          if (Array.isArray(filter.value) && filter.value.length > 0) {
            qb.andWhere(`${column} IN (:...${paramName})`, { [paramName]: filter.value });
          }
          break;
        case 'notIn':
          if (Array.isArray(filter.value) && filter.value.length > 0) {
            qb.andWhere(`${column} NOT IN (:...${paramName})`, { [paramName]: filter.value });
          }
          break;
        case 'like':
          qb.andWhere(`${column} LIKE :${paramName}`, {
            [paramName]: `%${filter.value}%`,
          });
          break;
        case 'iLike':
          qb.andWhere(`${column} ILIKE :${paramName}`, {
            [paramName]: `%${DatabaseUtils.escapeLikeString(String(filter.value))}%`,
          });
          break;
        case 'isNull':
          qb.andWhere(`${column} IS NULL`);
          break;
        case 'isNotNull':
          qb.andWhere(`${column} IS NOT NULL`);
          break;
        case 'between':
          if (Array.isArray(filter.value) && filter.value.length === 2) {
            const startParam = `${paramName}_start`;
            const endParam = `${paramName}_end`;
            qb.andWhere(`${column} BETWEEN :${startParam} AND :${endParam}`, {
              [startParam]: filter.value[0],
              [endParam]: filter.value[1],
            });
          }
          break;
      }
    });

    return qb;
  }

  /**
   * Applies case-insensitive ILIKE search across multiple text fields.
   */
  static applySearch<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    searchFields: string[] = [],
    searchQuery: string,
    alias?: string,
  ): SelectQueryBuilder<T> {
    if (!searchQuery || searchFields.length === 0) return qb;

    const targetAlias = alias || qb.alias;
    const escapedQuery = `%${DatabaseUtils.escapeLikeString(searchQuery.trim())}%`;
    const searchConditions: string[] = [];
    const params: Record<string, unknown> = {};

    searchFields.forEach((field, index) => {
      const sanitizedField = DatabaseUtils.sanitizeIdentifier(field);
      const column = sanitizedField.includes('.')
        ? sanitizedField
        : `${targetAlias}.${sanitizedField}`;
      const paramName = `search_param_${index}`;

      searchConditions.push(`${column} ILIKE :${paramName}`);
      params[paramName] = escapedQuery;
    });

    qb.andWhere(`(${searchConditions.join(' OR ')})`, params);
    return qb;
  }

  /**
   * Applies date range bounds filtering (`startDate` and `endDate`).
   */
  static applyDateRange<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    fieldName: string,
    startDate?: Date | string,
    endDate?: Date | string,
    alias?: string,
  ): SelectQueryBuilder<T> {
    const targetAlias = alias || qb.alias;
    const sanitizedField = DatabaseUtils.sanitizeIdentifier(fieldName);
    const column = sanitizedField.includes('.')
      ? sanitizedField
      : `${targetAlias}.${sanitizedField}`;

    if (startDate) {
      const start = startDate instanceof Date ? startDate.toISOString() : startDate;
      qb.andWhere(`${column} >= :startDate`, { startDate: start });
    }

    if (endDate) {
      const end = endDate instanceof Date ? endDate.toISOString() : endDate;
      qb.andWhere(`${column} <= :endDate`, { endDate: end });
    }

    return qb;
  }

  /**
   * Scopes soft delete handling (includes or excludes records with `deleted_at`).
   */
  static applySoftDelete<T extends ObjectLiteral>(
    qb: SelectQueryBuilder<T>,
    includeDeleted: boolean = false,
    alias?: string,
  ): SelectQueryBuilder<T> {
    if (includeDeleted) {
      qb.withDeleted();
    } else {
      const targetAlias = alias || qb.alias;
      qb.andWhere(`${targetAlias}.deleted_at IS NULL`);
    }
    return qb;
  }
}
