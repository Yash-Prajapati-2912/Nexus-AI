import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Expense } from '../entities/expense.entity';
import { QueryExpenseDto } from '../dto/query-expense.dto';
import { DateRangePreset } from '../constants/finance-enums.constants';
import { ICategoryBreakdown } from '../interfaces/category-breakdown.interface';

@Injectable()
export class ExpenseRepository extends BaseRepository<Expense> {
  constructor(
    @InjectRepository(Expense)
    private readonly expenseRepo: Repository<Expense>,
  ) {
    super(expenseRepo);
  }

  async findFilteredExpenses(
    userId: string,
    queryDto: QueryExpenseDto,
    entityManager?: EntityManager,
  ): Promise<{ data: Expense[]; total: number }> {
    const repo = this.getRepo(entityManager);
    const qb = repo
      .createQueryBuilder('expense')
      .leftJoinAndSelect('expense.category', 'category')
      .where('expense.userId = :userId', { userId });

    // Search query on title, merchant, description
    if (queryDto.search) {
      qb.andWhere(
        '(LOWER(expense.title) LIKE LOWER(:search) OR LOWER(expense.description) LIKE LOWER(:search) OR LOWER(expense.merchant) LIKE LOWER(:search))',
        { search: `%${queryDto.search.trim()}%` },
      );
    }

    if (queryDto.merchant) {
      qb.andWhere('LOWER(expense.merchant) LIKE LOWER(:merchant)', {
        merchant: `%${queryDto.merchant.trim()}%`,
      });
    }

    if (queryDto.categoryId) {
      qb.andWhere('expense.categoryId = :categoryId', { categoryId: queryDto.categoryId });
    }

    if (queryDto.budgetId) {
      qb.andWhere('expense.budgetId = :budgetId', { budgetId: queryDto.budgetId });
    }

    if (queryDto.paymentMethod) {
      qb.andWhere('expense.paymentMethod = :paymentMethod', { paymentMethod: queryDto.paymentMethod });
    }

    if (queryDto.isRecurring !== undefined) {
      qb.andWhere('expense.isRecurring = :isRecurring', { isRecurring: queryDto.isRecurring });
    }

    if (queryDto.minAmount !== undefined) {
      qb.andWhere('expense.amount >= :minAmount', { minAmount: queryDto.minAmount });
    }

    if (queryDto.maxAmount !== undefined) {
      qb.andWhere('expense.amount <= :maxAmount', { maxAmount: queryDto.maxAmount });
    }

    if (queryDto.tags) {
      const tagList = queryDto.tags.split(',').map((t) => t.trim()).filter(Boolean);
      if (tagList.length > 0) {
        qb.andWhere('expense.tags LIKE ANY(ARRAY[:...tagList])', {
          tagList: tagList.map((t) => `%${t}%`),
        });
      }
    }

    // Handle Date Filtering (Preset or Custom Range)
    this.applyDateFilters(qb, queryDto);

    // Sorting
    const sortField = queryDto.sortBy || 'expenseDate';
    const sortOrder = queryDto.sortOrder || 'DESC';
    if (sortField === 'category') {
      qb.orderBy('category.name', sortOrder);
    } else {
      qb.orderBy(`expense.${sortField}`, sortOrder);
    }

    // Pagination
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, queryDto.limit || 20);
    qb.skip((page - 1) * limit).take(limit);

    const [data, total] = await qb.getManyAndCount();
    return { data, total };
  }

  private applyDateFilters(qb: any, queryDto: QueryExpenseDto): void {
    const now = new Date();
    if (queryDto.dateRangePreset === DateRangePreset.TODAY) {
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const endOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);
      qb.andWhere('expense.expenseDate BETWEEN :startOfDay AND :endOfDay', { startOfDay, endOfDay });
    } else if (queryDto.dateRangePreset === DateRangePreset.THIS_WEEK) {
      const firstDayOfWeek = new Date(now.setDate(now.getDate() - now.getDay()));
      firstDayOfWeek.setHours(0, 0, 0, 0);
      qb.andWhere('expense.expenseDate >= :firstDayOfWeek', { firstDayOfWeek });
    } else if (queryDto.dateRangePreset === DateRangePreset.THIS_MONTH) {
      const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
      const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
      qb.andWhere('expense.expenseDate BETWEEN :startOfMonth AND :endOfMonth', { startOfMonth, endOfMonth });
    } else if (queryDto.startDate || queryDto.endDate) {
      if (queryDto.startDate && queryDto.endDate) {
        qb.andWhere('expense.expenseDate BETWEEN :startDate AND :endDate', {
          startDate: new Date(queryDto.startDate),
          endDate: new Date(queryDto.endDate),
        });
      } else if (queryDto.startDate) {
        qb.andWhere('expense.expenseDate >= :startDate', { startDate: new Date(queryDto.startDate) });
      } else if (queryDto.endDate) {
        qb.andWhere('expense.expenseDate <= :endDate', { endDate: new Date(queryDto.endDate) });
      }
    }
  }

  async calculateTotalSpentForPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<number> {
    const repo = this.getRepo(entityManager);
    const startDate = new Date(Date.UTC(year, month - 1, 1, 0, 0, 0));
    const endDate = new Date(Date.UTC(year, month, 0, 23, 59, 59, 999));

    const result = await repo
      .createQueryBuilder('expense')
      .select('SUM(expense.amount)', 'total')
      .where('expense.user_id = :userId', { userId })
      .andWhere('expense.expense_date BETWEEN :startDate AND :endDate', { startDate, endDate })
      .andWhere('expense.deleted_at IS NULL')
      .getRawOne();

    return result && result.total ? parseFloat(result.total) : 0;
  }

  async getCategoryBreakdownForPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<ICategoryBreakdown[]> {
    const repo = this.getRepo(entityManager);
    const startDate = new Date(Date.UTC(year, month - 1, 1, 0, 0, 0));
    const endDate = new Date(Date.UTC(year, month, 0, 23, 59, 59, 999));

    const rawResults = await repo
      .createQueryBuilder('expense')
      .innerJoin('expense.category', 'category')
      .select('category.id', 'categoryId')
      .addSelect('category.name', 'categoryName')
      .addSelect('category.colour', 'colour')
      .addSelect('category.icon', 'icon')
      .addSelect('SUM(expense.amount)', 'totalAmount')
      .where('expense.user_id = :userId', { userId })
      .andWhere('expense.expense_date BETWEEN :startDate AND :endDate', { startDate, endDate })
      .andWhere('expense.deleted_at IS NULL')
      .groupBy('category.id')
      .addGroupBy('category.name')
      .addGroupBy('category.colour')
      .addGroupBy('category.icon')
      .orderBy('SUM(expense.amount)', 'DESC')
      .getRawMany();

    const grandTotal = rawResults.reduce((acc, curr) => acc + parseFloat(curr.totalAmount), 0);

    return rawResults.map((row) => {
      const amount = parseFloat(row.totalAmount);
      return {
        categoryId: row.categoryId,
        categoryName: row.categoryName,
        colour: row.colour || '#6366F1',
        icon: row.icon || 'tag',
        totalAmount: amount,
        percentage: grandTotal > 0 ? parseFloat(((amount / grandTotal) * 100).toFixed(2)) : 0,
      };
    });
  }
}
