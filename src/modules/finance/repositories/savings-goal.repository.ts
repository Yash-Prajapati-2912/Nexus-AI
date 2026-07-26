import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { SavingsGoal } from '../entities/savings-goal.entity';

@Injectable()
export class SavingsGoalRepository extends BaseRepository<SavingsGoal> {
  constructor(
    @InjectRepository(SavingsGoal)
    private readonly savingsGoalRepo: Repository<SavingsGoal>,
  ) {
    super(savingsGoalRepo);
  }

  async findUserSavingsGoals(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<SavingsGoal[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { priority: 'ASC', targetDate: 'ASC' },
    });
  }

  async calculateTotalSavingsAccumulated(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<number> {
    const repo = this.getRepo(entityManager);
    const result = await repo
      .createQueryBuilder('goal')
      .select('SUM(goal.current_amount)', 'total')
      .where('goal.user_id = :userId', { userId })
      .andWhere('goal.deleted_at IS NULL')
      .getRawOne();

    return result && result.total ? parseFloat(result.total) : 0;
  }
}
