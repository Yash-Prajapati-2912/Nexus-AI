import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Income } from '../entities/income.entity';
import { QueryIncomeDto } from '../dto/query-income.dto';
import { FinanceDateUtils } from '../utils/finance-date.utils';

@Injectable()
export class IncomeRepository extends BaseRepository<Income> {
  constructor(
    @InjectRepository(Income)
    private readonly incomeRepo: Repository<Income>,
  ) {
    super(incomeRepo);
  }

  async findFilteredIncomes(
    userId: string,
    queryDto: QueryIncomeDto,
    entityManager?: EntityManager,
  ): Promise<{ data: Income[]; total: number }> {
    const repo = this.getRepo(entityManager);
    const qb = repo
      .createQueryBuilder('income')
      .where('income.userId = :userId', { userId });

    if (queryDto.source) {
      qb.andWhere('LOWER(income.source) LIKE LOWER(:source)', {
        source: `%${queryDto.source.trim()}%`,
      });
    }

    if (queryDto.frequency) {
      qb.andWhere('income.frequency = :frequency', { frequency: queryDto.frequency });
    }

    if (queryDto.isRecurring !== undefined) {
      qb.andWhere('income.isRecurring = :isRecurring', { isRecurring: queryDto.isRecurring });
    }

    if (queryDto.startDate && queryDto.endDate) {
      const startDate = FinanceDateUtils.parseStartDate(queryDto.startDate);
      const endDate = FinanceDateUtils.parseEndDate(queryDto.endDate);
      qb.andWhere('income.receivedDate BETWEEN :startDate AND :endDate', {
        startDate,
        endDate,
      });
    } else if (queryDto.startDate) {
      const startDate = FinanceDateUtils.parseStartDate(queryDto.startDate);
      qb.andWhere('income.receivedDate >= :startDate', { startDate });
    } else if (queryDto.endDate) {
      const endDate = FinanceDateUtils.parseEndDate(queryDto.endDate);
      qb.andWhere('income.receivedDate <= :endDate', { endDate });
    }

    qb.orderBy('income.receivedDate', 'DESC');

    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, queryDto.limit || 20);
    qb.skip((page - 1) * limit).take(limit);

    const [data, total] = await qb.getManyAndCount();
    return { data, total };
  }

  async calculateTotalIncomeForPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<number> {
    const repo = this.getRepo(entityManager);
    const startDate = FinanceDateUtils.getStartOfMonth(year, month);
    const endDate = FinanceDateUtils.getEndOfMonth(year, month);

    const result = await repo
      .createQueryBuilder('income')
      .select('SUM(income.amount)', 'total')
      .where('income.user_id = :userId', { userId })
      .andWhere('income.received_date BETWEEN :startDate AND :endDate', { startDate, endDate })
      .andWhere('income.deleted_at IS NULL')
      .getRawOne();

    return result && result.total ? parseFloat(result.total) : 0;
  }
}
