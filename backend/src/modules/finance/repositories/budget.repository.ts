import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Budget } from '../entities/budget.entity';
import { BudgetStatus } from '../constants/finance-enums.constants';

@Injectable()
export class BudgetRepository extends BaseRepository<Budget> {
  constructor(
    @InjectRepository(Budget)
    private readonly budgetRepo: Repository<Budget>,
  ) {
    super(budgetRepo);
  }

  async findByUserAndPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<Budget | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId, month, year },
    });
  }

  async findActiveByUserAndPeriod(
    userId: string,
    month: number,
    year: number,
    entityManager?: EntityManager,
  ): Promise<Budget | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: [
        { userId, month, year, status: BudgetStatus.ACTIVE },
        { userId, month, year, status: BudgetStatus.EXCEEDED },
      ],
    });
  }

  async findUserBudgets(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<Budget[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { year: 'DESC', month: 'DESC' },
    });
  }
}
